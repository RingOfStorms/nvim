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

local nvx = { "n", "v", "x" }

require("util").keymaps({
  -- =============
  -- n/v/x (normal + visual modes)
  -- =============
  { ";", ":", desc = "No shift to enter command mode with semicolon. Alias ; to :", mode = nvx },
  { "<leader>a", "<esc>ggVG", desc = "Select all", mode = nvx },
  { "<leader>w", "<cmd>w<cr>", desc = "Save", mode = nvx },
  {
    "<leader>q",
    function()
      -- Use to have this which always closed and quit ont he last screen: "<cmd>confirm q<cr>"
      -- Instead I want this behavior:
      -- if only 1 screen is open then close all buffers, resulting in a blank unnamed buffer window similar to fresh session
      -- else if more than 1 screen, confirm q to close that screen
      -- Check the number of screens
      if vim.fn.winnr("$") == 1 then
        -- If only 1 screen is open then close all buffers, resulting in a blank unnamed buffer window similar to fresh session
        vim.cmd("bufdo bd")
        vim.cmd("SessionDelete")
      else
        -- If more than 1 screen, confirm q to close that screen
        vim.cmd("confirm q")
      end
    end,
    desc = "Quit",
    mode = nvx,
  },
  { "Q", "<cmd>NvimTreeClose<cr><cmd>qa<CR>", desc = "Quit all", mode = nvx },
  -- { "Q", "<cmd>qa<CR>", desc = "Quit all", mode = nvx },
  { "<leader>Q", "<nop>", mode = nvx }, -- don't do normal Q quit
  {
    "<leader>QQ",
    "<cmd>NvimTreeClose<cr><cmd>SessionDelete<cr><cmd>qa<CR>",
    desc = "Quit all, no session saved",
    mode = nvx,
  },
  { "<leader>y", '"+y', desc = "Copy to system clipboard", mode = nvx },
  { "<leader>p", '"+p', desc = "Paste from system clipboard", mode = nvx },
  { "<leader>bq", "<cmd>bp|bd #<cr>", desc = "Close current buffer only", mode = nvx },
  { "<leader>bn", "<cmd>enew<cr>", desc = "Open a new buffer in current screen", mode = nvx },
  { "<leader>bt", "<cmd>terminal<cr>i", desc = "Open a terminal in current screen", mode = nvx },
  { "<leader>tn", "<cmd>tabnew<cr>", desc = "Create new tab", mode = nvx },
  { "<leader>tq", "<cmd>tabclose<cr>", desc = "Close current tab", mode = nvx },

  {
    "<leader>S",
    "<cmd>set equalalways<cr><cmd>set noequalalways<cr>",
    desc = "Equalize/resize screens evenly",
    mode = nvx,
  },
  { "<C-h>", "<C-w>h", desc = "Move window left current", mode = nvx },
  { "<C-j>", "<C-w>j", desc = "Move window below current", mode = nvx },
  { "<C-k>", "<C-w>k", desc = "Move window above current", mode = nvx },
  { "<C-l>", "<C-w>l", desc = "Move window right current", mode = nvx },
  { "B", "<cmd>b#<cr>", desc = "Switch to last buffer", mode = nvx },
  {
    "<leader>l<leader>",
    function()
      -- vim.cmd "SqlxFormat"
      vim.lsp.buf.format()
    end,
    desc = "Reformat file",
    mode = nvx,
  },
  {
    "<leader>ls<leader>",
    "<cmd>SqlxFormat<cr>",
    desc = "Format sqlx queries in rust raw string literals.",
    mode = nvx,
  },
  {
    "<leader>ld",
    function()
      vim.diagnostic.open_float()
    end,
    desc = "Show diagnostic message",
    mode = nvx,
  },
  {
    "<leader>ll",
    function()
      vim.diagnostic.setloclist()
    end,
    desc = "Show diagnostic list",
    mode = nvx,
  },

  -- =============
  -- normal mode
  -- =============
  -- { "", "", desc = "" },
  { "H", "<cmd>tabprevious<cr>", desc = "Move to previous tab" },
  { "L", "<cmd>tabnext<cr>", desc = "Move to next tab" },
  { "|", "<cmd>vsplit<cr>", desc = "Vertical Split" },
  { "\\", "<cmd>split<cr>", desc = "Horizontal Split" },
  { "n", "nzzzv", desc = "Next search result centered" },
  { "N", "Nzzzv", desc = "Previous search result centered" },
  { "<esc>", ":noh<CR><esc>", desc = "Clear search on escape" },
  { "<return>", ":noh<CR><return>", desc = "Clear search on return" },
  { "<C-d>", "<C-d>zz", desc = "Vertical half page down and center cursor" },
  { "<C-u>", "<C-u>zz", desc = "Vertical half page up and center cursor" },
  { "J", "mzJ`z", desc = "Move line below onto this line" },
  { "<S-Tab>", "<C-o>", desc = "Go back <C-o>" },
  {
    "]d",
    function()
      vim.diagnostic.goto_next()
    end,
    desc = "Go to next diagnostic",
  },
  {
    "[d",
    function()
      vim.diagnostic.goto_prev()
    end,
    desc = "Go to next diagnostic",
  },

  -- =============
  -- VISUAL
  -- =============
  {
    "J",
    ":m '>+1<CR>gv=gv",
    desc = "Visually move block down",
    mode = "v",
  },
  {
    "K",
    ":m '<-2<CR>gv=gv",
    desc = "Visually move block up",
    mode = "v",
  },
  {
    "<leader>,uu",
    'd:let @u = trim(tolower(system("uuidgen")))<cr>i<C-r>u',
    desc = "Generate and replace UUID",
    mode = "v",
  },
  { "p", '"_dP', desc = "Paste without yanking replaced content", mode = "v" },
  { "<C-r>", '"hy:%s/<C-r>h//g<left><left>', desc = "Replace current selection", mode = "v" },
  { ">", "> gv", desc = "Indent selection", mode = "v" },
  { "<", "< gv", desc = "Outdent selection", mode = "v" },

  -- =============
  -- insert / command
  -- =============
  { "<C-k>", "<Up>", desc = "Up", mode = { "i", "c" } },
  { "<C-j>", "<Down>", desc = "Down", mode = { "i", "c" } },
  { "<C-h>", "<Left>", desc = "Left", mode = { "i", "c" } },
  { "<C-l>", "<Right>", desc = "Right", mode = { "i", "c" } },
  { "<C-4>", "<End>", desc = "End", mode = { "i", "c" } },
  { "<C-6>", "<Home>", desc = "Home", mode = { "i", "c" } },
  -- =============
  -- command
  -- =============
  -- { mode = "c" }
  -- =============
  -- terminal
  -- =============
  { "<Esc>", "<C-\\><C-n>", desc = "Escape the terminal", mode = "t" },
})
