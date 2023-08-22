return {
  "Almo7aya/openingh.nvim",
  event = "BufEnter",
  keys = {
    { "<leader>gf", "<cmd>OpenInGHFile<CR>",      desc = "Open in git" },
    { "<leader>gf", "<cmd>OpenInGHFileLines<CR>", desc = "Open in git", mode = { "v" } },
  },
}
