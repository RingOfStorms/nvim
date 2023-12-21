return {
  "nvim-telescope/telescope-file-browser.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").load_extension("file_browser")
  end,
  keys = {
    { "<leader>e", "<cmd>Telescope file_browser<cr>", desc = "Open file browser" },
    { "<leader>o", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>", desc = "Open file browser" },
  },
}
