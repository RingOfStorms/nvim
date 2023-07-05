return {
	"rest-nvim/rest.nvim",
	event = "BufEnter *.http",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{
			"<leader>r",
			function()
				require("rest-nvim").run()
			end,
			desc = "Send selected http request",
		},
	},
}
