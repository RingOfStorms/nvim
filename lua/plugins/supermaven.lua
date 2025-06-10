return {
	"supermaven-inc/supermaven-nvim",
	event = "VeryLazy",
	opts = {
		keymaps = {
			accept_suggestion = "<C-space>",
			-- clear_suggestion = "<C-]>",
			accept_word = "<C-enter>",
		},
		ignore_filetypes = { "age" },
		-- disable_inline_completion = true,
		-- disable_keymaps = true,
		condition = function()
			local matches = vim.fn.expand("%:t"):match("^%.env") or vim.fn.expand("%:t"):match("^%.envrc")
			return not matches
		end,
	},
}
