return {
	"uga-rosa/ccc.nvim",
	event = "BufEnter",
	opts = {
		auto_enable = true,
		lsp = true,
		point_char = "󰫢",
	},
	config = function(_, opts)
		require("ccc").setup(opts)
		vim.api.nvim_create_autocmd("BufRead", {
			group = vim.api.nvim_create_augroup("myconfig-color-picker-group", { clear = true }),
			callback = function()
				vim.cmd.CccHighlighterEnable()
			end,
		})
	end,
	keys = {
		{ "<leader>,p", "<cmd>CccPick<cr>", desc = "Color Picker", mode = { "n", "v", "x" } },
	},
}
