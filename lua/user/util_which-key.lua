return {
	"folke/which-key.nvim",
	commit = "e271c28118998c93a14d189af3395812a1aa646c", -- May 22, 2023
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
		icons = { group = vim.g.icons_enabled and "" or "+", separator = "" },
		disable = { filetypes = { "TelescopePrompt" } },
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
}
