return {
	"numToStr/Comment.nvim",
	dependencies = {
		{
			-- This will auto change the commentstring option in files that could have varying
			-- comment modes like in jsx/markdown/files with embedded languages
			"JoosepAlviste/nvim-ts-context-commentstring",
			init = function()
				-- skip backwards compatibility routines and speed up loading
				vim.g.skip_ts_context_commentstring_module = true
			end,
			config = function()
				require("ts_context_commentstring").setup({})
			end,
		},
	},
	config = function()
		require("Comment").setup({
			pre_hook = function()
				return vim.bo.commentstring
			end,
			mappings = {
				basic = false,
				extra = false,
			},
		})
		vim.cmd("filetype plugin on")
	end,
	keys = {
		{
			"<leader>/",
			"<Plug>(comment_toggle_linewise_visual)",
			'<ESC><CMD>lua require("Comment.api").locked("toggle.linewise")(vim.fn.visualmode())<CR>',
			mode = { "x" },
			desc = "Toggle comments on selection",
		},
		{
			"<leader>/",
			"V<Plug>(comment_toggle_linewise_visual)",
			'<ESC><CMD>lua require("Comment.api").locked("toggle.linewise")(vim.fn.visualmode())<CR>',
			mode = { "n" },
			desc = "Toggle comments on line",
		},
	},
}
