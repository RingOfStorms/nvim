local U = require("util")

return {
  "rest-nvim/rest.nvim",
  enabled = function()
    return U.cmd_executable("curl", {
      [false] = function()
        vim.notify("curl not installed, http rest disabled", 2)
      end,
    })
  end,
  event = "BufEnter *.http",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    encode_url = false,
  },
  config = function(_, opts)
    require("rest-nvim").setup(opts)
  end,
  keys = {
    {
      "<leader>r",
      function()
        require("rest-nvim").run()
      end,
      desc = "Send selected http request",
    },
  },
}
