return {
  "voldikss/vim-floaterm",
  cmd = { "FloatermNew", "FloatermToggle" },
  keys = {
    {
      "<leader>xx",
      "<cmd>:'<,'>FloatermNew --autoclose=2<cr>",
      desc = "Run selected as command in float terminal",
      mode = "v",
    },
    {
      "<C-x>",
      "<cmd>FloatermToggle<cr>",
      desc = "Toggle float terminal",
      mode = { "n", "i", "v", "x", "c", "t" },
    },
    {
      "<C-z>",
      "<cmd>FloatermNew --disposable<cr>",
      desc = "Toggle disposable float terminal",
      mode = { "v", "n", "i", "x", "c" },
    },
  },
}
