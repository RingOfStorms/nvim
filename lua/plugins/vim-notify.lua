return {
  "rcarriga/nvim-notify",
  dependencies = "nvim-telescope/telescope.nvim",
  lazy = false,
  priority = 999,
  opts = {
    top_down = false,
  },
  config = function(_, opts)
    require("notify").setup(opts)

    vim.notify = require("notify")
    require('telescope').load_extension("notify")
  end,
  keys = {
    { "<leader>fn", "<cmd>Telescope notify<cr>", desc = "Telescope search notifications", mode = { "n", "v", "x" } },
  },
}
