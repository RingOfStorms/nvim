return {
  "lnc3l0t/glow.nvim",
  opts = {
    default_type = "keep",
  },
  cmd = "Glow",
  config = function(_, opts)
    -- Check for glow when plugin is first used
    if not U.cmd_executable("glow") then
      vim.notify(
        "'glow' not found on PATH. Install it to use markdown preview.",
        vim.log.levels.ERROR
      )
      return
    end
    require("glow").setup(opts)
  end,
  keys = {
    { "<leader>,m", "<cmd>Glow<cr>", desc = "Markdown preview" },
  },
}
