return {
  -- Smooth scrolling
  "declancm/cinnamon.nvim",
  event = "VeryLazy",
  opts = {
    extra_keymaps = true,
    extended_keymaps = true,
    -- override_keymaps = true,
    max_length = 300,
    default_delay = 2,
  },
  config = function(_, opts)
    require("cinnamon").setup(opts)
  end,
}
