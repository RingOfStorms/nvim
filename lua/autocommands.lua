--function isEmpty()
--return vim.api.nvim_buf_get_name(0) == ""
--or vim.fn.filereadable(vim.api.nvim_buf_get_name(0)) == 0
--or vim.fn.line("$") == 1 and vim.fn.col("$") == 1
--end

--vim.api.nvim_create_autocmd({ "VimEnter" }, {
--  callback = function()
--    if isEmpty() then
--      require('telescope.builtin').find_files()
--    end
--  end
--})

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

if vim.fn.exists(":CccHighlighterEnable") ~= 0 then
  vim.api.nvim_create_autocmd("BufRead", {
    callback = function()
      vim.cmd.CccHighlighterEnable()
    end,
  })
end

-- AUto exit insert mode whenever we switch screens
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = function()
    if vim.bo.filetype ~= "TelescopePrompt" and vim.bo.filetype ~= nil and vim.bo.filetype ~= "" then
      vim.api.nvim_command("stopinsert")
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "*.http",
  command = "set filetype=http",
})

--vim.api.nvim_create_autocmd('BufEnter', {
--  callback = function ()
--    local ts_avail, parsers = pcall(require, "nvim-treesitter.parsers")
--    if ts_avail and parsers.has_parser() then vim.cmd.TSBufEnable "highlight" end
--  end,
--})

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
