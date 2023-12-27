return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = function()
    local getWidth = function()
      local w = vim.api.nvim_get_option("columns")
      return math.ceil(w * 0.2)
    end

    vim.api.nvim_create_autocmd("VimResized", {
      pattern = "*",
      callback = function()
        vim.cmd("NvimTreeResize " .. tostring(getWidth()))
      end,
    })

    return {
      sort = {
        sorter = "case_sensitive",
      },
      view = {
        width = getWidth(),
      },
      renderer = {
        group_empty = true,
        indent_width = 1,
      },
      filters = {
        dotfiles = false,
        git_ignored = false,
      },
    }
  end,
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Open file browser" },
    { "<leader>o", "<cmd>NvimTreeFindFile<cr>", desc = "Open file browser at current buffer" },
  },
}
