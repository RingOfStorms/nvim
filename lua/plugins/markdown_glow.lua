return {
  "lnc3l0t/glow.nvim",
  branch = "advanced_window",
  config = {
    default_type = "keep",
  },
  cmd = "Glow",
	keys = {
		{ "<leader>m","<Nop>", desc = " Markdown"  },
		{ "<leader>mp",":Glow <CR>", desc = "Markdown preview" },
	},
}
