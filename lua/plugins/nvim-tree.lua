return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    sort = {
      sorter = "case_sensitive",
    },
    view = {
      width = 30,
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = false,
    },
  },
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<cr>",          desc = "Open file browser" },
    { "<leader>o", "<cmd>NvimTreeFindFile<cr>", desc = "Open file browser at current buffer" },
  },
}
