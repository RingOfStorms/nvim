return {
	"marko-cerovac/material.nvim",
	commit = "0c725897bc3d22c45fbf25a602002ee02f06f619", -- May 22, 2023
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
