return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
  cmd = "Neotree",
  init = function()
    vim.g.neo_tree_remove_legacy_commands = true
  end,
  pin = true,
  tag = "2.56",
  opts = {
    window = {
      position = "float",
    },
    auto_clean_after_session_restore = true,
    close_if_last_window = true,
    sources = { "filesystem" },
    filesystem = {
      follow_current_file = false,
      group_empty_dirs = true,
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        never_show = {
          ".DS_Store",
        },
      },
    },
    use_libuv_file_watcher = true,
    nesting_rules = {
      ["ts"] = { "cjs", "cjs.map", "d.ts", "d.ts.map", "js", "js.map", "mjs", "mjs.map", "test.ts" },
      ["js"] = { "cjs", "cjs.map", "d.js", "d.js.map", "js", "js.map", "mjs", "mjs.map", "test.js" },
      ["tsx"] = { "d.ts", "d.ts.map", "js", "js.map", "jsx", "jsx.map", "module.scss", "svg" },
      -- ["scss"] = { "css", "css.map" },
    },
  },
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle Explorer" },
    {
      "<leader>o",
      function()
        if vim.bo.filetype == "neo-tree" then
          vim.cmd.wincmd("p")
        else
          vim.cmd.Neotree("reveal")
        end
      end,
      desc = "Toggle Explorer Focus",
    },
  },
}
