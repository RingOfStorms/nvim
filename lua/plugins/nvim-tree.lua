return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = function()
    -- Not needed for our float config, if we remove the float mode then this works nicely for sidebar
    -- local getWidth = function()
    --   local w = vim.api.nvim_get_option("columns")
    --   return math.ceil(w * 0.2)
    -- end

    -- vim.api.nvim_create_autocmd("VimResized", {
    --   pattern = "*",
    --   callback = function()
    --     vim.cmd("NvimTreeResize " .. tostring(getWidth()))
    --   end,
    -- })

    return {
      sort = {
        sorter = "case_sensitive",
      },
      view = {
        -- width = getWidth(),
        float = {
          enable = true,
          open_win_config = function()
            local cols = vim.api.nvim_get_option("columns")
            local rows = vim.api.nvim_get_option("lines")
            local width = math.floor(cols / 2)
            local height = math.floor(rows / 1.2)
            return {
              relative = "editor",
              row = math.floor(rows / 10),
              col = math.floor(cols / 4),
              width = width,
              height = height,
              border = "rounded",
            }
          end,
        },
      },
      renderer = {
        group_empty = true,
        indent_width = 1,
        icons = {
          glyphs = {
            git = {
              unstaged = "",
            },
          },
        },
      },
      diagnostics = {
        enable = true,
        severity = {
          min = vim.diagnostic.severity.ERROR,
          max = vim.diagnostic.severity.ERROR,
        }
      },
      filters = {
        dotfiles = false,
        git_ignored = false,
        exclude = { ".DS_Store" },
      },
      actions = {
        open_file = {
          quit_on_open = true,
          window_picker = {
            enable = false,
          },
        },
      },
    }
  end,
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<cr>",   desc = "Open file browser" },
    { "<leader>o", "<cmd>NvimTreeFindFile<cr>", desc = "Open file browser at current buffer" },
  },
}
