vim.g.NERDCreateDefaultMappings = 0
vim.cmd('filetype plugin on')

return {
  "preservim/nerdcommenter",
  keys = {
    { "<leader>/", ':call nerdcommenter#Comment(0, "toggle")<CR>', desc = "Toggle comments on selection" },
    { "<leader>/", ':call nerdcommenter#Comment(0, "toggle")<CR>', desc = "Toggle comments on selection", mode = "v" },
  },
}
