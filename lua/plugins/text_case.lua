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
        if next(vim.lsp.buf_get_clients()) ~= nil then
          -- TODO test that this works
          vim.cmd("TextCaseOpenTelescopeLSPChange")
        else
          vim.cmd("TextCaseOpenTelescope")
        end
      end,
      desc = "Change case of selection",
      mode = { "n", "v", "x" },
      silent = true, -- TODO add this to most things....
    },
  },
}
