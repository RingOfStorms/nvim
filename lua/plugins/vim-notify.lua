return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  opts = {
    top_down = false,
  },
  config = function(_, opts)
    require("notify").setup(opts)

    vim.notify = require("notify")
  end,
  keys = {
    { "<leader>fn", "<cmd>Telescope notify<cr>", desc = "Telescope search notifications", mode = { "n", "v", "x" } },
  },
}
