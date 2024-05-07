return {
  -- Smooth scrolling
  "declancm/cinnamon.nvim",
  event = "VeryLazy",
  opts = {
    default_keymaps = true,
    max_length = 150,
    default_delay = 1,
    hide_cursor = true,
  },
  config = function(_, opts)
    require("cinnamon").setup(opts)
  end,
}
