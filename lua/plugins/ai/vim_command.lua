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

		local function call_ollama(prompt, mode_info, callback)
			local system_prompt = [[You are a Neovim command generator. Output ONLY the raw vim command or normal mode keystrokes that achieve what the user wants. No explanation, no markdown, no backticks, just the command itself.

Rules:
- For ex commands, prefix with : (e.g., :%s/foo/bar/g or :sort u)
- For normal mode commands, output the keystrokes directly (e.g., ggdG or ciw)
- If a visual selection is active, the command will be run with '<,'> range for ex commands, so omit the range prefix — just start with : (e.g., :s/foo/bar/g not :'<,'>s/foo/bar/g). For normal mode commands in visual mode, assume the selection is already active.
- Never include <CR> or <Enter> at the end
- Prefer concise, idiomatic vim commands]]

			local user_msg = prompt
			if mode_info.visual then
				user_msg = user_msg .. "\n[Context: visual selection active"
				if mode_info.selected_text and #mode_info.selected_text < 500 then
					user_msg = user_msg .. ", selected text: " .. vim.json.encode(mode_info.selected_text)
				end
				user_msg = user_msg .. "]"
			end
			if mode_info.filetype and mode_info.filetype ~= "" then
				user_msg = user_msg .. "\n[Filetype: " .. mode_info.filetype .. "]"
			end

			local body = vim.json.encode({
				model = "qwen2.5-coder:7b",
				prompt = user_msg,
				system = system_prompt,
				stream = false,
				options = {
					temperature = 0.1,
				},
			})

			vim.system(
				{
					"curl",
					"-s",
					"-X",
					"POST",
					"http://localhost:11434/api/generate",
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
							err_msg = "Failed to connect to Ollama at localhost:11434 (exit code " .. obj.code .. ")"
						end
						callback(nil, err_msg)
						return
					end

					local raw = obj.stdout or ""
					local ok, decoded = pcall(vim.json.decode, raw)
					if not ok or not decoded or not decoded.response then
						callback(nil, "Unexpected response from Ollama: " .. raw:sub(1, 200))
						return
					end

					local cmd = vim.trim(decoded.response)
					cmd = cmd:gsub("^```%w*\n?", ""):gsub("\n?```$", "")
					cmd = vim.trim(cmd)
					callback(cmd, nil)
				end)
			)
		end

		local function execute_command(cmd, mode_info)
			if cmd:sub(1, 1) == ":" then
				local ex_cmd = cmd:sub(2)
				if mode_info.visual then
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
			table.insert(display_lines, "  [Enter] Run   [e] Edit   [Esc/q] Cancel")

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
				vim.notify("Asking Ollama...", vim.log.levels.INFO)
				call_ollama(value, mode_info, function(cmd, err)
					if err then
						vim.notify("Ollama error: " .. err, vim.log.levels.ERROR)
						return
					end
					if not cmd or cmd == "" then
						vim.notify("Ollama returned empty response", vim.log.levels.WARN)
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
