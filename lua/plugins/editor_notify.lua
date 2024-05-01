return {
  "rcarriga/nvim-notify",
  -- dependencies = { "nvim-telescope/telescope.nvim", optional = true },
  lazy = false,
  priority = 999,
  opts = {
    top_down = false,
    timeout = 3000,
  },
  config = function(_, opts)
    require("notify").setup(opts)
    vim.notify = require("notify")

    -- TODO move to telescope instead...
    -- if package.loaded["telescope"] then
    --   require("telescope").load_extension("notify")
    --   require("util").keymaps({
    --     {
    --       "<leader>fn",
    --       "<cmd>Telescope notify<cr>",
    --       desc = "Telescope search notifications",
    --       mode = { "n", "v", "x" },
    --     },
    --   })
    -- end
  end,
}
