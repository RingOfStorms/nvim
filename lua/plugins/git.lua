return {
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function()
      local highlight = require("util").highlight
      highlight("GitGutterAdd", { fg = "#688066", gui = "nocombine" })
      highlight("GitGutterUntracked", { fg = "#688066", gui = "nocombine" })
      highlight("GitGutterChange", { fg = "#666f80", gui = "nocombine" })
      highlight("GitGutterDelete", { fg = "#806666", gui = "nocombine" })
      highlight("GitGutterChangeDelete", { fg = "#806666", gui = "nocombine" })

      return {
        watch_gitdir = {
          interval = 100,
        },
        signs = {
          add = { hl = "GitGutterAdd" },
          change = { hl = "GitGutterChange" },
          delete = { hl = "GitGutterDelete" },
          topdelete = { hl = "GitGutterDelete" },
          changedelete = { hl = "GitGutterChangeDelete" },
          untracked = { hl = "GitGutterUntracked" },
        },
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
          delay = 0,
          ignore_whitespace = false,
        },
        on_attach = function()
          vim.keymap.set("n", "<leader>gb", function()
            package.loaded.gitsigns.toggle_current_line_blame()
          end, { desc = "Toggle git blame on current line" })
        end,
      }
    end,
  },
  {
    "Neogitorg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      integrations = {
        diffview = true,
      },
      sections = {
        recent = false,
      },
    },
    keys = {
      {
        "<leader>gs",
        function()
          require("neogit").open({ kind = "vsplit" })
        end,
      },
    },
  },
  {

    "sindrets/diffview.nvim",
    opts = {
      diff_binaries = false,
      enhanced_diff_hl = true,
      git_cmd = { "git" },
      use_icons = true,
      icons = {
        folder_closed = "",
        folder_open = "",
      },
      signs = {
        fold_closed = "",
        fold_open = "",
      },
      view = {
        merge_tool = {
          layout = "diff3_mixed",
          disable_diagnostics = true,
        },
      },
      file_panel = {
        listing_style = "tree",
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },
        win_config = {
          position = "left",
          width = 35,
        },
      },
      file_history_panel = {
        log_options = {
          git = {
            single_file = {
              diff_merges = "combined",
            },
            multi_file = {
              diff_merges = "first-parent",
            },
          },
        },
        win_config = {
          position = "bottom",
          height = 16,
        },
      },
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Opens git diff view." },
    },
  },
}
