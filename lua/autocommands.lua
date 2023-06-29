function isEmpty()
  return vim.api.nvim_buf_get_name(0) == "" or vim.fn.filereadable(vim.api.nvim_buf_get_name(0)) == 0 or vim.fn.line('$') == 1 and vim.fn.col('$') == 1
end
-- #000000
--
--
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    if isEmpty() then
      require('telescope.builtin').find_files()
    end
  end
})

vim.api.nvim_create_autocmd('BufRead', {
  pattern = ".env*",
  command = "set filetype=sh"
})

vim.api.nvim_create_autocmd('BufRead', {
  pattern = ".*rc",
  command = "set filetype=sh"
})

vim.api.nvim_create_autocmd('BufRead', {
  pattern = "Dockerfile.*",
  command = "set filetype=dockerfile"
})

vim.api.nvim_create_autocmd("BufRead", {
  callback = function()
    vim.cmd.CccHighlighterEnable()
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  callback = function ()
    local ts_avail, parsers = pcall(require, "nvim-treesitter.parsers")
    if ts_avail and parsers.has_parser() then vim.cmd.TSBufEnable "highlight" end
  end,
})
