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
      winblend = 10,
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.register({
      ["<leader>b"] = { name = "Buffers", mode = { "n", "x", "v", "c" } },
      ["<leader>t"] = { name = "Tabs", mode = { "n", "x", "v", "c" } },
      ["<leader>,"] = { name = "Miscellaneous Tools", mode = { "n", "x", "v", "c" } },
      -- ["<leader>c"] = { name = "Copilot" },
      ["<leader>f"] = { name = "Find [Telescope]", mode = { "n", "x", "v", "c" } },
      -- ["<leader>fs"] = { name = "Find in Scratches [Telescope]" },
      ["<leader>g"] = { name = "Git", mode = { "n", "x", "v", "c" } },
      ["<leader>l"] = { name = "LSP", mode = { "n", "x", "v", "c" } },
      ["<leader>lf"] = { name = "LSP Find", mode = { "n", "x", "v", "c" } },
      -- ["<leader>Q"] = { name = "+Q Quit and remove session" },
      -- ["<leader>s"] = { name = "Scratch Files" },
      -- ["<leader>x"] = { name = "Generative AI, Ollama" },
    })
  end,
}
