vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

vim.opt.foldcolumn = "0"
vim.opt.foldtext = ""

vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

vim.opt.foldnestmax = 3

vim.keymap.set('n', '<leader>z', function()
  local any_fold_open = false
  for lnum = 1, vim.fn.line('$') do
    if vim.fn.foldclosed(lnum) ~= -1 then
      any_fold_open = true
      break
    end
  end
  if any_fold_open then
    -- There's at least one closed fold, so open all
    vim.cmd('normal! zR')
  else
    -- All folds are open, so close all
    vim.cmd('normal! zM')
  end
end, { noremap = true, silent = true })
