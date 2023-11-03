return {
  "mbbill/undotree",
  event = "BufEnter",
  keys = {
    { "<leader>u", vim.cmd.UndotreeToggle, desc = "Undo Tree Toggle" },
  },
}
