-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("config-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 300 })
  end,
})

-- TODO is there a better way for these?
vim.api.nvim_create_autocmd("BufRead", {
  pattern = ".env*",
  command = "set filetype=sh",
})
vim.api.nvim_create_autocmd("BufRead", {
  pattern = ".*rc",
  command = "set filetype=sh",
})
vim.api.nvim_create_autocmd("BufRead", {
  pattern = "Dockerfile.*",
  command = "set filetype=dockerfile",
})
vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.http",
  command = "set filetype=http",
})

-- Auto exit insert mode whenever we switch screens
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = function()
    if vim.bo.filetype ~= "TelescopePrompt" and vim.bo.filetype ~= nil and vim.bo.filetype ~= "" then
      vim.api.nvim_command("stopinsert")
    end
  end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    vim.cmd("NvimTreeClose")
    -- Close all buffers with the 'httpResult' type
    local buffers = vim.api.nvim_list_bufs()
    for _, bufnr in ipairs(buffers) do
      if vim.bo[bufnr].filetype == "httpResult" then
        vim.api.nvim_buf_delete(bufnr, { force = true })
      end
    end
  end,
})
