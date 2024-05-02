return {
  "stevearc/conform.nvim",
  opts = {
    -- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#setup
    notify_on_error = true,
    formatters_by_ft = {
      lua = { "stylua" },
      typescript = { { "prettierd", "prettier" } },
      typescriptreact = { { "prettierd", "prettier" } },
      javascript = { { "prettierd", "prettier" } },
      javascriptreact = { { "prettierd", "prettier" } },
    },
  },
  keys = {
    {
      "<leader>l<leader>",
      function()
        require("conform").format({ async = true, lsp_fallback = true }, function(err, edited)
          if edited then
            print("Formatted!")
          else
            print("Nothing to format!")
          end
        end)
      end,
      mode = { "n", "v", "x" },
      desc = "Format buffer",
    },
  },
}
