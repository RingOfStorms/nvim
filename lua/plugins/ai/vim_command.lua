return {
	"folke/snacks.nvim",
	optional = true,
	keys = {
		{
			"<leader>,v",
			function()
				local history_file = vim.fn.stdpath("state") .. "/llm_vim_command_history.json"
		local history = {}
		local history_index = 0

		local function load_history()
			local f = io.open(history_file, "r")
			if f then
				local content = f:read("*a")
				f:close()
				local ok, decoded = pcall(vim.json.decode, content)
				if ok and type(decoded) == "table" then
					history = decoded
				end
			end
		end

		local function save_history()
			local f = io.open(history_file, "w")
			if f then
				f:write(vim.json.encode(history))
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
			local system_prompt =
				[[You are a vim command generator. Given a task description, output ONLY a vim command or sequence of keystrokes that accomplishes the task. 
Rules:
- Output ONLY the vim command/keystrokes, nothing else
- No explanations, no markdown, no code blocks
- For ex commands, start with : (e.g., :%s/foo/bar/g or :sort u)
- For normal mode sequences, just output the keys
- If the task works on a selection, assume visual mode is active (for ex commands, start with :'<,'> or : without a range)
- Never include <CR> or <Enter> at the end
- Keep commands as simple and idiomatic as possible]]

			local body = vim.json.encode({
				model = "air-gpt-5.1",
				messages = {
					{ role = "system", content = system_prompt },
					{ role = "user", content = prompt },
				},
				temperature = 0.1,
			})

			vim.system(
				{
					"curl",
					"-s",
					"-X",
					"POST",
					"http://litellm.joshuabell.xyz/v1/chat/completions",
					"-H",
					"Content-Type: application/json",
					"-d",
					body,
				},
				{ text = true },
				vim.schedule_wrap(function(obj)
					if obj.code ~= 0 then
						local err_msg = vim.trim(obj.stderr or "")
						if err_msg == "" then
							err_msg = "exit code " .. obj.code
						end
						callback(nil, "curl failed: " .. err_msg)
						return
					end

					local response_body = vim.trim(obj.stdout or "")
					if response_body == "" then
						callback(nil, "curl returned empty response. stderr: " .. vim.trim(obj.stderr or ""))
						return
					end

					local ok, decoded = pcall(vim.json.decode, response_body)
					if not ok or not decoded or not decoded.choices or not decoded.choices[1] then
						callback(nil, "Failed to parse LLM response: " .. response_body:sub(1, 200))
						return
					end

					local command = vim.trim(decoded.choices[1].message.content or "")
					command = command:gsub("^```%w*\n?", ""):gsub("\n?```$", "")
					callback(vim.trim(command), nil)
				end)
			)
		end
		local function execute_command(cmd, mode_info)
			if cmd:sub(1, 1) == ":" then
				local ex_cmd = cmd:sub(2)
				if mode_info.visual and not ex_cmd:match("^'<,'>") and not ex_cmd:match("^%%") then
					ex_cmd = "'<,'>" .. ex_cmd
				end
				vim.fn.histadd("cmd", ex_cmd)
				local ok, err = pcall(vim.cmd, ex_cmd)
				if not ok then
					vim.notify("Command failed: " .. tostring(err), vim.log.levels.ERROR)
				end
			else
				if mode_info.visual then
					vim.cmd("normal! gv")
				end
				local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
				vim.api.nvim_feedkeys(keys, "n", false)
			end
		end

		local function show_edit_dialog(command, mode_info)
			Snacks.input({
				prompt = "Edit Vim Command",
				default = command,
			}, function(val)
				if val and val ~= "" then
					execute_command(val, mode_info)
				end
			end)
		end

		local function show_confirmation(command, mode_info)
			local lines = vim.split(command, "\n")
			local max_line_len = 0
			for _, line in ipairs(lines) do
				max_line_len = math.max(max_line_len, #line)
			end
			local width = math.max(40, math.min(80, max_line_len + 4))
			local height = #lines + 2

			local display_lines = {}
			for _, line in ipairs(lines) do
				table.insert(display_lines, "  " .. line)
			end
			table.insert(display_lines, "")
			table.insert(display_lines, "  [y/Enter] Run   [e] Edit   [Esc/q] Cancel")

			Snacks.win({
				title = " LLM Vim Command ",
				title_pos = "center",
				width = width,
				height = height,
				border = "rounded",
				enter = true,
				bo = { modifiable = false, buftype = "nofile" },
				text = display_lines,
				keys = {
					["y"] = function(self)
						self:close()
						execute_command(command, mode_info)
					end,
					["<CR>"] = function(self)
						self:close()
						execute_command(command, mode_info)
					end,
					["e"] = function(self)
						self:close()
						show_edit_dialog(command, mode_info)
					end,
					["q"] = "close",
					["<Esc>"] = "close",
				},
			})
		end

		local function get_visual_selection()
			local start_pos = vim.fn.getpos("'<")
			local end_pos = vim.fn.getpos("'>")
			local start_line, start_col = start_pos[2], start_pos[3]
			local end_line, end_col = end_pos[2], end_pos[3]

			if start_line == 0 or end_line == 0 then
				return nil
			end

			local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
			if #lines == 0 then
				return nil
			end

			if #lines == 1 then
				lines[1] = lines[1]:sub(start_col, end_col)
			else
				lines[1] = lines[1]:sub(start_col)
				lines[#lines] = lines[#lines]:sub(1, end_col)
			end

			return table.concat(lines, "\n")
		end

		local function show_prompt_dialog(visual)
			local mode_info = {
				visual = visual,
				filetype = vim.bo.filetype,
				selected_text = nil,
			}

			if visual then
				vim.cmd('normal! "vy')
				mode_info.selected_text = get_visual_selection()
			end

			history_index = #history + 1

			Snacks.input({
				prompt = visual and "LLM Vim Command (visual)" or "LLM Vim Command",
				win = {
					keys = {
						i_up = {
							"<Up>",
							function(self)
								if #history == 0 then
									return
								end
								history_index = math.max(1, history_index - 1)
								vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, { history[history_index] })
								vim.cmd("startinsert!")
							end,
							mode = { "i", "n" },
						},
						i_down = {
							"<Down>",
							function(self)
								if #history == 0 then
									return
								end
								history_index = math.min(#history + 1, history_index + 1)
								local text = history_index <= #history and history[history_index] or ""
								vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, { text })
								vim.cmd("startinsert!")
							end,
							mode = { "i", "n" },
						},
					},
				},
			}, function(value)
				if not value or value == "" then
					return
				end
				add_to_history(value)
				local full_prompt = value
				if mode_info.visual and mode_info.selected_text and mode_info.selected_text ~= "" then
					full_prompt = full_prompt .. "\n\nThe current selection is:\n" .. mode_info.selected_text
				end
				vim.notify("Generating vim command...", vim.log.levels.INFO)
				call_llm(full_prompt, function(cmd, err)
					if err then
						vim.notify(err, vim.log.levels.ERROR)
						return
					end
					if not cmd or cmd == "" then
						vim.notify("LLM returned empty response", vim.log.levels.WARN)
						return
					end
					show_confirmation(cmd, mode_info)
				end)
			end)
		end
				local mode = vim.fn.mode()
				show_prompt_dialog(mode == "v" or mode == "V" or mode == "\22")
			end,
			mode = { "n", "v" },
			desc = "LLM Vim Command",
		},
	},
}
