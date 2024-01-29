return {
  "catppuccin/nvim",
  opts = {
    -- flavour = "frappe", -- latte, frappe, macchiato, mocha (default)
    -- color_overrides = {
    --   mocha = {
    --     -- base = "#0e0e14",
    --     -- mantle = "#000000",
    --     -- crust = "#000000",
    --   },
    -- },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
  end,
}
