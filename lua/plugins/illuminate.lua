-- This plugin will smartly highlight the token under the cursor.
return {
  "RRethy/vim-illuminate",
  opts = {},
  config = function(_, opts)
    require("illuminate").configure(opts)
  end,
}