return {
	"marko-cerovac/material.nvim",
	config = function()
		vim.g.material_style = "darker"
		require("material").setup {
			plugins = {
				"dashboard",
				"gitsigns",
				"telescope",
				"nvim-tree",
				"which-key",
			},
			high_visibility = {
				darker = true
			}
		}
	end
}
