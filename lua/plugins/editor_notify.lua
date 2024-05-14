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
  end,
}
