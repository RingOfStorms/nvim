-- allow use of system keyboard
vim.opt.clipboard = "unnamedplus"
-- allow use of mouse
vim.opt.mouse = 'a'
-- line numbering, relative
vim.opt.number = true
vim.wo.number = true
vim.wo.relativenumber = true
-- Highlights the results of previous search, which is annoying when we are done searching
vim.opt.hlsearch = false
-- Wrap lines in files
vim.opt.wrap = true
-- preseve indentation of virtual wrapped lines
vim.opt.breakindent = true
-- set tab length
vim.opt.tabstop = 2;
vim.opt.shiftwidth = 2;
-- split to the right or below always
vim.opt.splitbelow = true
vim.opt.splitright = true
