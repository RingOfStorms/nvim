return {
  "rest-nvim/rest.nvim",
	commit = "d8dc204e9f6fd930d9d1d709f0d19138f804431a",
  event = "BufEnter *.http",
  requires = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>r",  function() require("rest-nvim").run() end, desc = "Send http request" }
	}
}
