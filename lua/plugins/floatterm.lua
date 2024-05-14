return {
  "voldikss/vim-floaterm",
  cmd = { "FloatermToggle" },
  keys = {
    {
      "<C-x>",
      "<cmd>FloatermToggle<cr>",
      desc = "Toggle float terminal",
      mode = { "n", "i", "v", "x", "c", "t" },
    },
  },
}
