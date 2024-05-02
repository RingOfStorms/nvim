return {
  "lewis6991/gitsigns.nvim",
  event = "BufEnter",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = function()
    local highlight = U.highlight
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
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 0,
        virt_text = false,
      },
    }
  end,
  config = function(_, opts)
    require("gitsigns").setup(opts)
  end,
}
