return {
  "preservim/nerdcommenter",
  dependencies = {
    {
      -- This will auto change the commentstring option in files that could have varying
      -- comment modes like in jsx/markdown/files with embedded languages
      "JoosepAlviste/nvim-ts-context-commentstring",
      init = function()
        -- skip backwards compatibility routines and speed up loading
        vim.g.skip_ts_context_commentstring_module = true
      end,
      config = function()
        require("ts_context_commentstring").setup({})
      end,
    },
  },
  config = function()
    vim.g.NERDCreateDefaultMappings = 0
    vim.g.NERDDefaultAlign = "both"
    vim.g.NERDSpaceDelims = 1
    vim.cmd("filetype plugin on")
  end,
  keys = {
    { "<leader>/", "<Plug>NERDCommenterToggle<cr>k", mode = { "n", "x" } },
  },
}
