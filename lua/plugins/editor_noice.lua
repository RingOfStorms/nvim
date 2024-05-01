return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    messages = {
      view = "mini", -- default view for messages
      view_error = "notify", -- view for errors
      view_warn = "mini", -- view for warnings
      view_history = "messages", -- view for :messages
      view_search = false, -- view for search count messages. Set to `false` to disable
    },
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
      },
    },
  },
  config = function(_, opts)
    require("noice").setup(opts)
  end,
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify",
  },
}
