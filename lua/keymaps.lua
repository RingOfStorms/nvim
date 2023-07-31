-- Remap space as leader key
vim.keymap.set("", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes  test
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

require("util").keymaps({
  n = {
    [";"] = { ":", desc = "No shift command mode" },
    ["n"] = { "nzzzv", desc = "Next search result centered" },
    ["N"] = { "Nzzzv", desc = "Previous search result centered" },
    ["<esc>"] = { ":noh<CR><esc>", desc = "Clear search on escape" },
    ["<return>"] = { ":noh<CR><return>", desc = "Clear search on return" },
    ["<leader>a"] = { "ggVG", desc = "Select all" },
    ["<leader>w"] = { "<cmd>w<cr>", desc = "Save" },
    ["<leader>q"] = { "<cmd>confirm q<cr>", desc = "Quit" },
    ["<leader>cq"] = { "<cmd>bd<cr>", desc = "Close current buffer" },
    ["|"] = { "<cmd>vsplit<cr>", desc = "Vertical Split" },
    ["\\"] = { "<cmd>split<cr>", desc = "Horizontal Split" },
    ["<C-d>"] = { "<C-d>zz", desc = "Vertical half page down and center cursor" },
    ["<C-u>"] = { "<C-u>zz", desc = "Vertical half page up and center cursor" },
    ["<leader>y"] = { '"*y', desc = "Copy to system clipboard" },
    ["<leader>p"] = { '"*p', desc = "Paste from system clipboard" },
    ["<leader>Q"] = { ":qa<CR>", desc = "Quit all" },
    ["J"] = { "mzJ`z", desc = "Move line below onto this line" },
    -- window navigation
    ["<C-h>"] = { "<C-w>h", desc = "Move window left current" },
    ["<C-j>"] = { "<C-w>j", desc = "Move window below current" },
    ["<C-k>"] = { "<C-w>k", desc = "Move window above current" },
    ["<C-l>"] = { "<C-w>l", desc = "Move window right current" },
    -- reformat LSP
    ["<leader>lf"] = {
      function()
        -- vim.cmd "SqlxFormat"
        vim.lsp.buf.format()
      end,
      desc = "Reformat file",
    },
    ["<leader>lsf"] = { "<cmd>SqlxFormat<cr>", desc = "Format sqlx queries in rust raw string literals." },
    ["<leader>ld"] = {
      function()
        vim.diagnostic.open_float()
      end,
      desc = "Show diagnostic message",
    },
    ["<leader>ll"] = {
      function()
        vim.diagnostic.setloclist()
      end,
      desc = "Show diagnostic list",
    },
    ["<leader>lz"] = { "<cmd>e<CR>", desc = "Edit current file again / Restart LSP Server" },
    ["<leader>,uu"] = { ':let @u = trim(tolower(system("uuidgen")))<cr>a<C-r>u', desc = "Generate and insert UUID" },
    ["<leader>b"] = { "<cmd>b#<cr>", desc = "Switch to last buffer" },
  },
  v = {
    ["J"] = { ":m '>+1<CR>gv=gv", desc = "Visually move block down" },
    ["K"] = { ":m '<-2<CR>gv=gv", desc = "Visually move block up" },
    ["<leader>,uu"] = {
      'd:let @u = trim(tolower(system("uuidgen")))<cr>i<C-r>u',
      desc = "Generate and replace UUID",
    },
    ["<leader>y"] = { '"*y', desc = "Copy to system clipboard" },
    ["<leader>p"] = { '"*p', desc = "Paste from system clipboard" },
    ["p"] = { '"_dP', desc = "Paste without yanking replaced content" },
    ["<C-r>"] = { '"hy:%s/<C-r>h//g<left><left>', desc = "Replace current selection" },
  },
  i = {
    ["<C-k>"] = { "<Up>", desc = "Up" },
    ["<C-j>"] = { "<Down>", desc = "Down" },
    ["<C-h>"] = { "<Left>", desc = "Left" },
    ["<C-l>"] = { "<Right>", desc = "Right" },
    ["<C-4>"] = { "<End>", desc = "End" },
    ["<C-6>"] = { "<Home>", desc = "Home" },
  },
  c = {
    ["<C-h>"] = { "<Left>", desc = "Left" },
    ["<C-j>"] = { "<Down>", desc = "Down" },
    ["<C-k>"] = { "<Up>", desc = "Up" },
    ["<C-l>"] = { "<Right>", desc = "Right" },
    ["<C-4>"] = { "<End>", desc = "End" },
    ["<C-6>"] = { "<Home>", desc = "Home" },
  },
  t = {
    ["<Esc>"] = { "<C-\\><C-n>", desc = "Escape the terminal" },
  },
})
