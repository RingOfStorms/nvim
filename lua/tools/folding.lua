-- Smart folding: native treesitter for small files, indent for large files
local LARGE_FILE_THRESHOLD = 1000

local function setup_folding()
	local line_count = vim.api.nvim_buf_line_count(0)

	if line_count > LARGE_FILE_THRESHOLD then
		-- Large files: indent-based folding (fast)
		vim.opt_local.foldmethod = "indent"
	else
		-- Normal files: native treesitter folding
		vim.opt_local.foldmethod = "expr"
		vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	end
end

vim.api.nvim_create_autocmd({ "BufReadPost", "FileType" }, {
	group = vim.api.nvim_create_augroup("myconfig-smart-folding", { clear = true }),
	callback = setup_folding,
})

-- Global fold settings
vim.opt.foldcolumn = "0"
vim.opt.foldtext = ""
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldnestmax = 3

-- Toggle all folds with <leader>z
vim.keymap.set("n", "<leader>z", function()
	local any_fold_closed = false
	for lnum = 1, vim.fn.line("$") do
		if vim.fn.foldclosed(lnum) ~= -1 then
			any_fold_closed = true
			break
		end
	end
	if any_fold_closed then
		vim.cmd("normal! zR")
	else
		vim.cmd("normal! zM")
	end
end, { noremap = true, silent = true, desc = "Toggle all folds" })
