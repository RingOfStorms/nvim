return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 250
  end,
  opts = {
    window = {
      border = "single",
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    wk.register({
      ["<leader>b"] = { name = "Buffers" },
      ["<leader>,"] = { name = "Miscellaneous Tools" },
      ["<leader>c"] = { name = "Copilot" },
      ["<leader>f"] = { name = "Find [Telescope]" },
      ["<leader>fs"] = { name = "Find in Scratches [Telescope]" },
      ["<leader>g"] = { name = "Git" },
      ["<leader>l"] = { name = "LSP" },
      ["<leader>lf"] = { name = "LSP Find" },
      ["<leader>Q"] = { name = "+Q Quit and remove session" },
      ["<leader>s"] = { name = "Scratch Files" },
      ["<leader>t"] = { name = "Tabs" },
    })
  end,
}
