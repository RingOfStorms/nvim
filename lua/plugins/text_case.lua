return {
  "johmsalas/text-case.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  cmd = "TextCaseOpenTelescope",
  config = function(_, opts)
    require("textcase").setup(opts)
    require("telescope").load_extension("textcase")
  end,
  keys = {
    {
      "<leader>,c",
      function()
        if next(vim.lsp.get_active_clients()) ~= nil then
          vim.cmd("TextCaseOpenTelescopeLSPChange")
        else
          vim.cmd("TextCaseOpenTelescope")
        end
      end,
      desc = "Change case of selection",
      mode = { "n", "v", "x" },
    },
  },
}
