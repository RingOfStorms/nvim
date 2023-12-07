return {
  "johmsalas/text-case.nvim",
  dependencies = "nvim-telescope/telescope.nvim",
  event = "BufEnter",
  config = function(_, opts)
    require("textcase").setup(opts)
    require("telescope").load_extension("textcase")
  end,
  keys = {
    { "<leader>,c", ":TextCaseOpenTelescope<cr>", desc = "Change case of selection", mode = { "n", "v" } },
  },
}
