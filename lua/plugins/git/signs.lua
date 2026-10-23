return {
	"lewis6991/gitsigns.nvim",
	event = "BufEnter",
	opts = function()
		vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#66B066", nocombine = true })
		vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = "#66B066", nocombine = true })
		vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#666FB0", nocombine = true })
		vim.api.nvim_set_hl(0, "GitSignsTopdelete", { fg = "#B06666", nocombine = true })
		vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#B06666", nocombine = true })
		vim.api.nvim_set_hl(0, "GitSignsChangeDelete", { fg = "#B06666", nocombine = true })
		return {
			watch_gitdir = {
				interval = 100,
			},
			current_line_blame = true,
			current_line_blame_opts = {
				virt_text = false,
			},
		}
	end,
	config = function(_, opts)
		require("gitsigns").setup(opts)
	end,
}
