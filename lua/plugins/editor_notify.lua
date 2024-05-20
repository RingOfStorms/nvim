return {
	"rcarriga/nvim-notify",
	lazy = false,
	priority = 150,
	opts = {
		top_down = false,
		timeout = 5000,
	},
	config = function(_, opts)
		require("notify").setup(opts)
    vim.notify = require("notify")

		U.safeRequire("telescope", function(t)
			t.load_extension("notify")
		end)
	end,
	keys = {
		{
			"<leader>fn",
			"<cmd>Telescope notify<cr>",
			desc = "Telescope search notifications",
			mode = { "n", "v", "x" },
		},
	},
}
