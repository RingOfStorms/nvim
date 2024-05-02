local group = vim.api.nvim_create_augroup("myconfig-autocommands-group", { clear = true });
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  desc = "Highlight when yanking (copying) text",
  callback = function()
    vim.highlight.on_yank({ timeout = 300 })
  end,
})

-- TODO is there a better way for these?
vim.api.nvim_create_autocmd("BufRead", {
  group = group,
  pattern = ".env*",
  command = "set filetype=sh",
})
vim.api.nvim_create_autocmd("BufRead", {
  group = group,
  pattern = ".*rc",
  command = "set filetype=sh",
})
vim.api.nvim_create_autocmd("BufRead", {
  group = group,
  pattern = "Dockerfile.*",
  command = "set filetype=dockerfile",
})
vim.api.nvim_create_autocmd("BufRead", {
  group = group,
  pattern = "*.http",
  command = "set filetype=http",
})

-- Auto exit insert mode whenever we switch screens
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  group = group,
  callback = function()
    if vim.bo.filetype ~= "TelescopePrompt" and vim.bo.filetype ~= nil and vim.bo.filetype ~= "" then
      vim.api.nvim_command("stopinsert")
    end
  end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = group,
  callback = function()
    vim.cmd("NvimTreeClose")
    -- Close all buffers with the 'httpResult' type
    local close_types = { "httpResult", "noice", "help" }
    local buffers = vim.api.nvim_list_bufs()
    for _, bufnr in ipairs(buffers) do
      if U.table_contains(close_types, vim.bo[bufnr].filetype) then
        vim.api.nvim_buf_delete(bufnr, { force = true })
      end
    end
  end,
})
