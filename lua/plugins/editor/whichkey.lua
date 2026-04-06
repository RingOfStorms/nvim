return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 250
	end,
	opts = {
		preset = "helix",
		win = {
			wo = {
				winblend = 8,
			},
		},
		spec = {
			{
				mode = { "n", "v", "x" },
				{ "<leader>,", group = "Miscellaneous Tools" },
				{ "<leader>b", group = "Buffers" },
				{ "<leader>f", group = "Find" },
				{ "<leader>g", group = "Git" },
				{ "<leader>l", group = "LSP" },
				{ "<leader>lf", group = "LSP Find" },
				{ "<leader>t", group = "Tabs" },
				{ "<leader>s", group = "Scratch" },
				{ "<leader>u", group = "UI" },
				{ "<leader>x", group = "Trouble/Diagnostics" },
			},
		},
	},
	config = true,
}
