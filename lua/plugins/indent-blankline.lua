vim.cmd([[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent4 guifg=#61AFEF gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent5 guifg=#C678DD gui=nocombine]])

vim.opt.list = true
-- vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append("eol:↴")

return {
	-- Add indentation guides even on blank lines
	"lukas-reineke/indent-blankline.nvim",
	-- Enable `lukas-reineke/indent-blankline.nvim`
	-- See `:help indent_blankline.txt`
	opts = {
		-- space_char_blankline = " ",
		-- char = '┊',
		-- show_trailing_blankline_indent = false,
		-- show_current_context = false,
		show_current_context_start = true,
		char_highlight_list = {
			"IndentBlanklineIndent1",
			"IndentBlanklineIndent2",
			"IndentBlanklineIndent3",
			"IndentBlanklineIndent4",
			"IndentBlanklineIndent5",
		},
	},
}
