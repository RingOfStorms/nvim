local U = require("util")

return {
  "David-Kunz/gen.nvim",
  enabled = function()
    return U.cmd_executable("ollama", {
      [false] = function()
        vim.notify("ollama not installed, gen disabled", 2)
      end,
    }) and U.cmd_executable("curl", {
      [false] = function()
        vim.notify("curl not installed, gen disabled", 2)
      end,
    })
  end,
  opt = { show_model = true },
  keys = {
    {
      "<leader>xx",
      "<cmd>Gen Generate<cr>",
      desc = "Input and generate",
      mode = { "n", "i", "v", "x" },
    },
    {
      "<leader>xx",
      "<cmd>Gen Enhance_Code<cr>",
      desc = "Enhance selected code",
      mode = { "v", "x" },
    },
    {
      "<leader>xm",
      "<cmd>Gen<cr>",
      desc = "Show Menu",
      mode = { "n", "i", "v", "x" },
    },
  },
}
