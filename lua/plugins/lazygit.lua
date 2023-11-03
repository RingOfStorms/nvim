local function prereqs()
  local output = vim.fn.system({
    "which",
    "lazygit",
  })
  if output == nil or output == "" then
    print("Installing lazygit with rtx")
    -- if v:shell_error != 0 then
    vim.fn.system({
      "rtx",
      "global",
      "lazygit@latest",
    })
    vim.fn.system({
      "rtx",
      "install",
    })
  end
end

return {
  "kdheepak/lazygit.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  build = prereqs,
  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Open lazy git ui" },
  },
}
