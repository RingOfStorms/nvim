return {
	"rest-nvim/rest.nvim",
	event = "BufEnter *.http",
	dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    encode_url = false,
  },
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
