return {
  "Almo7aya/openingh.nvim",
  cmd = { "OpenInGHFile", "OpenInGHFileLines" },
  keys = {
    { "<leader>gf", "<cmd>OpenInGHFile<CR>", desc = "Open in git" },
    { "<leader>gf", ":OpenInGHFileLines<CR>", desc = "Open in git", mode = { "v", "x" } },
  },
}

