return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim" },
    { "nvim-telescope/telescope-ui-select.nvim" },
  },
  init = function()
    U.cmd_executable("rg", {
      [false] = function()
        vim.notify("rg not installed, live grep will not function.", 2)
      end,
    })
  end,
  cmd = "Telescope",
  opts = function()
    return {
      pickers = {
        buffers = {
          sort_lastused = true,
        },
        find_files = {
          hidden = true,
          sort_lastused = true,
        },
        live_grep = {
          hidden = true,
        },
      },
      defaults = {
        file_ignore_patterns = { "node_modules", "package-lock.json", "target", ".git" },
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
        },
        vimgrep_arguments = {
          "rg",
          "--hidden",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_cursor(),
        },
        ["notify"] = {},
      },
    }
  end,
  config = function(_, opts)
    local ts = require("telescope")
    ts.setup(opts)
    ts.load_extension("ui-select")

    if package.loaded["notify"] then
      ts.load_extension("notify")
      U.keymaps({
        {
          "<leader>fn",
          "<cmd>Telescope notify<cr>",
          desc = "Telescope search notifications",
          mode = { "n", "v", "x" },
        },
      })
    end
  end,
  -- https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#pickers
  keys = {
    {
      "<leader>fr",
      function()
        require("telescope.builtin").resume()
      end,
      desc = "Resume last telescope",
    },
    {
      "<leader>f/",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find(
          require("telescope.themes").get_dropdown({ winblend = 10, previewer = false })
        )
      end,
      desc = "Fuzzy find/search in current buffer fuzzy.",
    },
    {
      "<leader>fh",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "Find help",
    },
    {
      "<leader>ff",
      function()
        require("telescope.builtin").find_files({
          hidden = true,
        })
      end,
      desc = "Find Files",
    },
    {
      "<leader>fg",
      function()
        require("telescope.builtin").git_files({
          hidden = true,
        })
      end,
      desc = "Find Git only Files",
    },
    {
      "<leader>fw",
      function()
        U.cmd_executable("rg", {
          function()
            require("telescope.builtin").live_grep({
              hidden = true,
            })
          end,
          function()
            vim.notify("rg not installed, find words will not function.", 3)
          end,
        })
      end,
      desc = "Find Words",
    },
    {
      "<leader>fc",
      function()
        require("telescope.builtin").commands()
      end,
      desc = "Find Commands",
    },
    {
      "<leader>fk",
      function()
        require("telescope.builtin").keymaps()
      end,
      desc = "Find Keymap",
    },
    {
      "<leader>fb",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "Find Buffer",
    },
    {
      "<leader>lfr",
      function()
        require("telescope.builtin").lsp_references()
      end,
      desc = "Find LSP References",
      mode = { "n", "v", "x" },
    },
  },
}
