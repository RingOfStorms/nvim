local function prereqs()
  local output = vim.fn.system({
    "which",
    "rg",
  })
  if output == nil or output == "" or string.find(output, "not installed for the toolchain") then
    print("Installing ripgrep globally with rtx")
    vim.fn.system({
      "rtx",
      "global",
      "ripgrep@latest",
    })
  end
end

return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.1",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", enabled = vim.fn.executable("make") == 1, build = "make" },
  },
  build = prereqs,
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
          hidden = true
        })
      end,
      desc = "Find Files",
    },
    {
      "<leader>fg",
      function()
        require("telescope.builtin").git_files()
      end,
      desc = "Find Git only Files",
    },
    {
      "<leader>fw",
      function()
        require("telescope.builtin").live_grep({
          grep_open_files = true,
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
  },
  opts = {
    pickers = {
      buffers = {
        sort_lastused = true,
      },
      find_files = {
        hidden = true,
        sort_lastused = true,
      }
    },
    defaults = {
      file_ignore_patterns = { 'node_modules', 'package-lock.json', 'target' },
    },
  },
}
