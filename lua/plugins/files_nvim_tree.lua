return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = function()
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
        indent_width = 3,
        icons = {
          glyphs = {
            git = {
              unstaged = "",
            },
          },
        },
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
      on_attach = function(bufnr)
        -- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#modify-you-on_attach-function-to-have-ability-to-operate-multiple-files-at-once
        local api = require("nvim-tree.api")
        local opts = function(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        -- mark operation
        local mark_move_j = function()
          api.marks.toggle()
          vim.cmd("norm j")
        end
        local mark_move_k = function()
          api.marks.toggle()
          vim.cmd("norm k")
        end

        -- marked files operation
        local mark_remove = function()
          local marks = api.marks.list()
          if #marks == 0 then
            table.insert(marks, api.tree.get_node_under_cursor())
          end
          for _, node in ipairs(marks) do
            api.fs.remove(node)
          end
          api.marks.clear()
          api.tree.reload()
        end

        local mark_copy = function()
          local marks = api.marks.list()
          if #marks == 0 then
            table.insert(marks, api.tree.get_node_under_cursor())
          end
          for _, node in pairs(marks) do
            api.fs.copy.node(node)
          end
          api.marks.clear()
          api.tree.reload()
        end

        local mark_cut = function()
          local marks = api.marks.list()
          if #marks == 0 then
            table.insert(marks, api.tree.get_node_under_cursor())
          end
          for _, node in pairs(marks) do
            api.fs.cut(node)
          end
          api.marks.clear()
          api.tree.reload()
        end

        local mark_move_to_cursor = function()
          local marks = api.marks.list()
          if #marks == 0 then
            table.insert(marks, api.tree.get_node_under_cursor())
          end
          for _, node in pairs(marks) do
            api.fs.cut(node)
          end
          api.marks.clear()
          api.fs.paste()
          api.tree.reload()
        end

        vim.keymap.set("n", "J", mark_move_j, opts("Toggle Bookmark Down"))
        vim.keymap.set("n", "K", mark_move_k, opts("Toggle Bookmark Up"))

        vim.keymap.set("n", "x", mark_cut, opts("Cut File(s)"))
        vim.keymap.set("n", "d", mark_remove, opts("Remove File(s)"))
        vim.keymap.set("n", "y", mark_copy, opts("Copy File(s)"))

        vim.keymap.set("n", "<leader>mv", mark_move_to_cursor, opts("Move Bookmarked"))
        vim.keymap.set("n", "M", api.marks.clear, opts("Clear Bookmarks"))

        -- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#refactoring-of-on_attach-generated-code
        vim.keymap.set("n", "q", api.tree.close, opts("Close"))
        vim.keymap.set("n", "<esc>", api.tree.close, opts("Close"))
        vim.keymap.set("n", "<leader>o", api.tree.close, opts("Close"))
        vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "<C-v>", api.node.open.vertical, opts("Open in vertical split"))
        vim.keymap.set("n", "<C-x>", api.node.open.horizontal, opts("Open in horizontal split"))
        vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
        vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
        vim.keymap.set("n", "a", api.fs.create, opts("Create"))
        vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
        vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
        vim.keymap.set("n", "m", api.marks.toggle, opts("Toggle Bookmark"))

        vim.keymap.set("n", "<leader>c", api.fs.copy.absolute_path, opts("Copy Path to Clipboard"))

        vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))

        vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
      end,
    }
  end,
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Open file browser" },
    { "<leader>o", "<cmd>NvimTreeFindFile<cr>", desc = "Open file browser at current buffer" },
  },
}
