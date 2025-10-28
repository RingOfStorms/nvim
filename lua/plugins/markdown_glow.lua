return {
  "lnc3l0t/glow.nvim",
  init = function()
    -- Check if glow is available
    if not U.cmd_executable("glow") then
      vim.notify(
        "'glow' not found on PATH. Required for markdown preview with :Glow",
        vim.log.levels.INFO
      )
    end
  end,
  opts = {
    default_type = "keep",
  },
  cmd = "Glow",
  keys = {
    { "<leader>,m", "<cmd>Glow<cr>", desc = "Markdown preview" },
  },
}
