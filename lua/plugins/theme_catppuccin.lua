return {
  "catppuccin/nvim",
  -- load theme right away
  lazy = false,
  priority = 100,
  opts = {
    flavour = "mocha", -- latte, frappe, macchiato, mocha (default)
    color_overrides = {
      mocha = {
        -- My coal variant: https://gist.github.com/RingOfStorms/b2ff0c4e37f5be9f985c72c3ec9a3e62
        text = "#e0e0e0",
        subtext1 = "#cccccc",
        subtext0 = "#b8b8b8",
        overlay2 = "#a3a3a3",
        overlay1 = "#8c8c8c",
        overlay0 = "#787878",
        surface2 = "#636363",
        surface1 = "#4f4f4f",
        surface0 = "#3b3b3b",
        base = "#262626",
        mantle = "#1f1f1f",
        crust = "#171717",
      },
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
  end,
}
