return {
  "nvim-telescope/telescope.nvim",
  tag = '0.1.1',
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", enabled = vim.fn.executable "make" == 1, build = "make" },
  },
  cmd = "Telescope",
  keys = {
    { "<leader>f", "<Nop>", desc = "Find ..." },
    { "<leader>ff", function() require('telescope.builtin').find_files() end, desc = "Find Files" },
    { "<leader>fg", function() require('telescope.builtin').git_files() end, desc = "Find Git only Files" },
    { "<leader>fw", function() require('telescope.builtin').live_grep() end, desc = "Find Words" },
    { "<leader>fc", function() require('telescope.builtin').commands() end, desc = "Find Commands" },
    { "<leader>fk", function() require('telescope.builtin').keymaps() end, desc = "Find Commands" },
    { "<leader>fb", function() require('telescope.builtin').buffers() end, desc = "Find Commands" },
  },
  opts = {
    defaults = {
      vimgrep_arguments = {
        "rg",
        "-L",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
      }
    }
  },
}
