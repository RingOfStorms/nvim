return {
  "lukas-reineke/indent-blankline.nvim",
  event = "VeryLazy",
  opts = {
    scope = {
      enabled = true,
      char = "┊",
      show_start = false,
      show_end = false,
      highlight = {
        "IndentBlanklineScope1",
        "IndentBlanklineScope2",
        "IndentBlanklineScope3",
        "IndentBlanklineScope4",
        "IndentBlanklineScope5",
      },
    },
    indent = {
      char = "│",
      highlight = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
        "IndentBlanklineIndent5",
      },
    },
  },
  config = function(_, opts)
    U.highlight("NonText", { fg = "#303030", gui = "nocombine" })

    local hooks = require("ibl.hooks")
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "IndentBlanklineIndent1", { fg = "#915053" })
      vim.api.nvim_set_hl(0, "IndentBlanklineIndent2", { fg = "#A27F3E" })
      vim.api.nvim_set_hl(0, "IndentBlanklineIndent3", { fg = "#6B7F6E" })
      vim.api.nvim_set_hl(0, "IndentBlanklineIndent4", { fg = "#5a74aa" })
      vim.api.nvim_set_hl(0, "IndentBlanklineIndent5", { fg = "#6B6282" })

      vim.api.nvim_set_hl(0, "IndentBlanklineScope1", { fg = "#CB5D60" })
      vim.api.nvim_set_hl(0, "IndentBlanklineScope2", { fg = "#DEA93F" })
      vim.api.nvim_set_hl(0, "IndentBlanklineScope3", { fg = "#89B790" })
      vim.api.nvim_set_hl(0, "IndentBlanklineScope4", { fg = "#6289E5" })
      vim.api.nvim_set_hl(0, "IndentBlanklineScope5", { fg = "#917DC0" })
    end)

    require("ibl").setup(opts)
  end,
}
