-- This plugin will smartly highlight the token under the cursor.
return {
  "RRethy/vim-illuminate",
  event = "BufEnter",
  opts = {},
  config = function(_, opts)
    require("illuminate").configure(opts)
  end,
}
