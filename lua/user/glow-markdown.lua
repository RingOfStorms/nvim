return {
  "lnc3l0t/glow.nvim",
	commit = "bbd0473d72a45094495ee5600b5577823543eefe",
  branch = "advanced_window",
  config = {
    default_type = "keep",
  },
  cmd = "Glow",
	mappings = {
		n = {
			["<leader>m"] = { "<Nop>", name = " Markdown" },
			["<leader>mp"] = { ":Glow <CR>", desc = "Markdown preview" },
		}
	}
}
