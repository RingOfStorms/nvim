return {
  -- Smooth scrolling
  "declancm/cinnamon.nvim",
  event = "VeryLazy",
  opts = {
    default_keymaps = true,
    max_length = 180,
    default_delay = 2,
    hide_cursor = true,
  },
  config = function(_, opts)
    require("cinnamon").setup(opts)
  end,
}
