return {
	"johmsalas/text-case.nvim",
	config = function(_, opts)
		require("textcase").setup(opts)
	end,
	keys = {
		{
			"<leader>,c",
			function()
				require("textcase").open_telescope()
			end,
			desc = "Change case of selection",
			mode = { "n", "v", "x" },
		},
	},
}
