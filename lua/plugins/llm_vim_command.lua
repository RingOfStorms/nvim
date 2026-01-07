return {
	"MunifTanjim/nui.nvim",
	keys = {
		{ "<leader>,v", desc = "LLM Vim Command" },
	},
	config = function()
		local Input = require("nui.input")
		local Popup = require("nui.popup")

		local history_file = vim.fn.stdpath("state") .. "/llm_vim_command_history.json"
		local history = {}
		local history_index = 0

		local function load_history()
			local f = io.open(history_file, "r")
			if f then
				local content = f:read("*a")
				f:close()
				local ok, decoded = pcall(vim.fn.json_decode, content)
				if ok and type(decoded) == "table" then
					history = decoded
				end
			end
		end

		local function save_history()
			local f = io.open(history_file, "w")
			if f then
				f:write(vim.fn.json_encode(history))
				f:close()
			end
		end

		local function add_to_history(prompt)
			if prompt == "" then
				return
			end
			if #history > 0 and history[#history] == prompt then
				return
			end
			table.insert(history, prompt)
			if #history > 100 then
				table.remove(history, 1)
			end
			save_history()
		end

		load_history()

		local function call_llm(prompt, callback)
			local system_prompt = [[You are a vim command generator. Given a task description, output ONLY a vim command or sequence of keystrokes that accomplishes the task. 
Rules:
- Output ONLY the vim command/keystrokes, nothing else
- No explanations, no markdown, no code blocks
- For ex commands, start with :
- For normal mode sequences, just output the keys
- If the task mentions working on a selection, assume visual mode is active
- Keep commands as simple and idiomatic as possible]]

			local body = vim.fn.json_encode({
				model = "azure-gpt-5.1-2025-11-13",
				messages = {
					{ role = "system", content = system_prompt },
					{ role = "user", content = prompt },
				},
				temperature = 0.1,
			})

			local stdout_data = {}
			local stderr_data = {}

			vim.fn.jobstart({
				"curl",
				"-s",
				"-X", "POST",
				"http://h001.net.joshuabell.xyz:8094/v1/chat/completions",
				"-H", "Content-Type: application/json",
				"-d", body,
			}, {
				stdout_buffered = true,
				stderr_buffered = true,
				on_stdout = function(_, data)
					if data then
						for _, line in ipairs(data) do
							if line ~= "" then
								table.insert(stdout_data, line)
							end
						end
					end
				end,
				on_stderr = function(_, data)
					if data then
						for _, line in ipairs(data) do
							if line ~= "" then
								table.insert(stderr_data, line)
							end
						end
					end
				end,
				on_exit = vim.schedule_wrap(function(_, exit_code)
					if exit_code ~= 0 then
						local err_msg = table.concat(stderr_data, "\n")
						if err_msg == "" then
							err_msg = "exit code " .. exit_code
						end
						callback(nil, "curl failed: " .. err_msg)
						return
					end
					if #stdout_data == 0 then
						callback(nil, "curl returned empty response. stderr: " .. table.concat(stderr_data, "\n"))
						return
					end
					local response_body = table.concat(stdout_data, "")
					local ok, decoded = pcall(vim.fn.json_decode, response_body)
					if not ok or not decoded.choices or not decoded.choices[1] then
						callback(nil, "Failed to parse LLM response: " .. response_body)
						return
					end
					local command = decoded.choices[1].message.content
					command = command:gsub("^%s+", ""):gsub("%s+$", "")
					callback(command, nil)
				end),
			})
		end

		local function execute_command(command)
			if command:sub(1, 1) == ":" then
				local cmd = command:sub(2)
				vim.fn.histadd("cmd", cmd)
				local ok, err = pcall(vim.cmd, cmd)
				if not ok then
					vim.notify("Command failed: " .. err, vim.log.levels.ERROR)
				end
			else
				vim.api.nvim_feedkeys(
					vim.api.nvim_replace_termcodes(command, true, false, true),
					"n",
					false
				)
			end
		end

		local function show_edit_dialog(command)
			local input = Input({
				position = "50%",
				size = { width = 60 },
				border = {
					style = "rounded",
					text = { top = " Edit Command ", top_align = "center" },
				},
			}, {
				prompt = "> ",
				default_value = command,
				on_submit = function(value)
					if value and value ~= "" then
						execute_command(value)
					end
				end,
			})

			input:mount()
			input:map("n", "<Esc>", function()
				input:unmount()
			end, { noremap = true })
		end

		local function show_confirmation(command)
			local lines = vim.split(command, "\n")
			local max_line_len = 0
			for _, line in ipairs(lines) do
				max_line_len = math.max(max_line_len, #line)
			end
			local width = math.max(40, math.min(80, max_line_len + 4))
			local height = #lines + 4

			local popup = Popup({
				position = "50%",
				size = { width = width, height = height },
				border = {
					style = "rounded",
					text = { top = " LLM Vim Command ", top_align = "center" },
				},
				enter = true,
				focusable = true,
				buf_options = {
					modifiable = true,
					readonly = false,
				},
			})

			popup:mount()

			local content = {}
			for _, line in ipairs(lines) do
				table.insert(content, line)
			end
			table.insert(content, "")
			table.insert(content, string.rep("─", width - 2))
			table.insert(content, "[y] run  [e] edit  [q/Esc] cancel")

			vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, content)
			vim.api.nvim_buf_set_option(popup.bufnr, "modifiable", false)
			vim.cmd("stopinsert")

			local function close()
				popup:unmount()
			end

			popup:map("n", "q", close, { noremap = true })
			popup:map("n", "<Esc>", close, { noremap = true })

			popup:map("n", "y", function()
				close()
				execute_command(command)
			end, { noremap = true })

			popup:map("n", "e", function()
				close()
				show_edit_dialog(command)
			end, { noremap = true })
		end

		local function show_prompt_dialog(is_visual)
			local selection = nil
			if is_visual then
				vim.cmd('normal! "vy')
				selection = vim.fn.getreg("v")
			end

			history_index = #history + 1

			local popup = Popup({
				position = "50%",
				size = { width = 60, height = 5 },
				border = {
					style = "rounded",
					text = { top = " Describe vim task ", top_align = "center" },
				},
				enter = true,
				focusable = true,
				win_options = {
					wrap = true,
					linebreak = true,
				},
			})

			popup:mount()
			vim.api.nvim_buf_set_option(popup.bufnr, "modifiable", true)
			vim.api.nvim_buf_set_option(popup.bufnr, "buftype", "nofile")
			vim.cmd("startinsert")

			local function get_text()
				local lines = vim.api.nvim_buf_get_lines(popup.bufnr, 0, -1, false)
				return table.concat(lines, "\n"):gsub("^%s+", ""):gsub("%s+$", "")
			end

			local function set_text(text)
				local lines = vim.split(text, "\n")
				vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, lines)
				local last_line = lines[#lines] or ""
				vim.api.nvim_win_set_cursor(popup.winid, { #lines, #last_line })
			end

			local function close_popup()
				popup:unmount()
			end

			local function submit()
				local task = get_text()
				close_popup()

				if task == "" then
					return
				end

				add_to_history(task)

				local full_prompt = task
				if selection and selection ~= "" then
					full_prompt = full_prompt .. "\n\nThe current selection is:\n" .. selection
				end

				vim.notify("Generating vim command...", vim.log.levels.INFO)

				call_llm(full_prompt, function(command, err)
					if err then
						vim.notify(err, vim.log.levels.ERROR)
						return
					end
					show_confirmation(command)
				end)
			end

			popup:map("n", "<Esc>", close_popup, { noremap = true })
			popup:map("i", "<Esc>", close_popup, { noremap = true })
			popup:map("i", "<CR>", submit, { noremap = true })
			popup:map("n", "<CR>", submit, { noremap = true })

			local function history_prev()
				if #history == 0 then
					return
				end
				history_index = math.max(1, history_index - 1)
				set_text(history[history_index])
			end

			local function history_next()
				if #history == 0 then
					return
				end
				history_index = math.min(#history + 1, history_index + 1)
				if history_index > #history then
					set_text("")
				else
					set_text(history[history_index])
				end
			end

			popup:map("i", "<Up>", history_prev, { noremap = true })
			popup:map("i", "<Down>", history_next, { noremap = true })
			popup:map("i", "<C-k>", history_prev, { noremap = true })
			popup:map("i", "<C-j>", history_next, { noremap = true })
		end

		vim.keymap.set({ "n", "v" }, "<leader>,v", function()
			local mode = vim.fn.mode()
			show_prompt_dialog(mode == "v" or mode == "V" or mode == "\22")
		end, { desc = "LLM Vim Command" })
	end,
}
