local U = require("util")

return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.4",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", enabled = vim.fn.executable("make") == 1, build = "make" },
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
  keys = {
    { "<leader>f", "<Nop>", desc = "Find ..." },
    {
      "<leader>fr",
      function()
        require("telescope.builtin").resume()
      end,
      desc = "Resume last telescope",
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
            vim.notify("rg not installed, live grep will not function.", 3)
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
      desc = "Find Commands",
    },
    {
      "<leader>fb",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "Find Commands",
    },
    {
      "<leader>lfr",
      function()
        require("telescope.builtin").lsp_references()
      end,
      desc = "Find References",
      mode = { "n", "v", "x" },
    },
  },
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
      },
      defaults = {
        file_ignore_patterns = { "node_modules", "package-lock.json", "target" },
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_cursor(),
        },
      },
    }
  end,
  config = function(_, opts)
    local ts = require("telescope")
    ts.setup(opts)
    ts.load_extension("ui-select")
  end,
}
