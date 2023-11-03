return {
  "johmsalas/text-case.nvim",
  dependencies = "nvim-telescope/telescope.nvim",
  event = "BufEnter",
  config = function()
    require("textcase").setup()
    require("telescope").load_extension("textcase")
  end,
  keys = {
    { "<leader>,c", "<cmd>TextCaseOpenTelescope<cr>", desc = "Change case of selection", mode = { "n", "v" } },
  },
}
