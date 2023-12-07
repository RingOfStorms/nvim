return {
  "Almo7aya/openingh.nvim",
  event = "BufEnter",
  keys = {
    { "<leader>gf", ":OpenInGHFile<CR>", desc = "Open in git" },
    { "<leader>gf", ":OpenInGHFileLines<CR>", desc = "Open in git", mode = { "v" } },
  },
}
