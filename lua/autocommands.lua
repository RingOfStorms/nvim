local group = vim.api.nvim_create_augroup("myconfig-autocommands-group", { clear = true })
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	group = group,
	desc = "Highlight when yanking (copying) text",
	callback = function()
		vim.highlight.on_yank({ timeout = 300 })
	end,
})

-- TODO is there a better way for these?
-- https://www.youtube.com/watch?v=NecszftvMFI vim.filetype.add
vim.api.nvim_create_autocmd("BufRead", {
	group = group,
	pattern = ".env*",
	command = "set filetype=sh",
})
vim.api.nvim_create_autocmd("BufRead", {
	group = group,
	pattern = ".*rc",
	command = "set filetype=sh",
})
vim.api.nvim_create_autocmd("BufRead", {
	group = group,
	pattern = "Dockerfile.*",
	command = "set filetype=dockerfile",
})
vim.api.nvim_create_autocmd("BufRead", {
	group = group,
	pattern = "*.http",
	command = "set filetype=http",
})

-- Auto exit insert mode whenever we switch screens
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	group = group,
	callback = function()
		if vim.bo.filetype ~= "TelescopePrompt" and vim.bo.filetype ~= nil and vim.bo.filetype ~= "" then
			vim.api.nvim_command("stopinsert")
		end
	end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = group,
	callback = function()
		vim.cmd("NvimTreeClose")
		-- Close all buffers with the 'httpResult' type
		local close_types = { "httpResult", "noice", "help" }
		local buffers = vim.api.nvim_list_bufs()
		for _, bufnr in ipairs(buffers) do
			if U.table_contains(close_types, vim.bo[bufnr].filetype) then
				vim.api.nvim_buf_delete(bufnr, { force = true })
			end
		end
	end,
})

local auto_save_disallowed_filetypes = { "TelescopePrompt", "quickfix", "terminal" }
local auto_save_debounce = {}
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "TextChangedI", "BufLeave" }, {
	group = group,
	callback = function(event)
		local modifiable = vim.api.nvim_buf_get_option(event.buf, "modifiable")
		local filetype = vim.api.nvim_buf_get_option(event.buf, "filetype")
		local modified = vim.api.nvim_buf_get_option(event.buf, "modified")
		if
			modifiable
			and modified
			and U.table_not_contains(auto_save_disallowed_filetypes, filetype)
		then
			if auto_save_debounce[event.buf] ~= 1 then
				auto_save_debounce[event.buf] = 1
				vim.defer_fn(function()
					vim.api.nvim_buf_call(event.buf, function()
						vim.api.nvim_command("silent! write")
					end)
					auto_save_debounce[event.buf] = nil
				end, 500)
			end
		end
	end,
})
