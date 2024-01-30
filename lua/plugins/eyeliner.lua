-- This plugin will highlight all first letters after pressing f in the line.
return {
  "jinh0/eyeliner.nvim",
  opts = {
    highlight_on_key = true,
    dim = true,
  },
  config = function(_, opts)
    require("eyeliner").setup(opts)
  end,
}
