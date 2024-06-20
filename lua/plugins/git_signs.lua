return {
  "lewis6991/gitsigns.nvim",
  event = "BufEnter",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = function()
    local highlight = U.highlight
    highlight("GitSignsAdd", { fg = "#688066", gui = "nocombine" })
    highlight("GitSignsUntracked", { fg = "#688066", gui = "nocombine" })
    highlight("GitSignsChange", { fg = "#666f80", gui = "nocombine" })
    highlight("GitSignsTopdelete", { fg = "#806666", gui = "nocombine" })
    highlight("GitSignsDelete", { fg = "#806666", gui = "nocombine" })
    highlight("GitGutterChangeDelete", { fg = "#806666", gui = "nocombine" })

    return {
      watch_gitdir = {
        interval = 100,
      },
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = false,
      },
    }
  end,
  config = function(_, opts)
    require("gitsigns").setup(opts)
  end,
}
