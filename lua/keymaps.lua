local util = require("util")
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

util.keymaps({
  -- ===========
  --    Basic
  -- ===========
  { "<left>", '<cmd>echo "use h/j/k/l to move!"<cr>', mode = nvx },
  { "<right>", '<cmd>echo "use h/j/k/l to move!"<cr>', mode = nvx },
  { "<up>", '<cmd>echo "use h/j/k/l to move!"<cr>', mode = nvx },
  { "<down>", '<cmd>echo "use h/j/k/l to move!"<cr>', mode = nvx },
  { ";", ":", desc = "No shift to enter command mode with semicolon. Alias ; to :", mode = nvx },
  { "<leader>Q", "<nop>", mode = nvx }, -- don't do normal Q quit
  { "<leader>a", "<esc>ggVG", desc = "Select all", mode = nvx },
  { "Q", "<cmd>qa<CR>", desc = "Quit all", mode = nvx },
  {
    "<leader>QQ",
    -- TODO REVISIT is this session stuff still relevant?
    "<cmd>NvimTreeClose<cr><cmd>SessionDelete<cr><cmd>qa<CR>",
    desc = "Quit all, no session saved",
    mode = nvx,
  },
  { "<leader>y", '"+y', desc = "Copy to system clipboard", mode = nvx },
  { "<leader>p", '"+p', desc = "Paste from system clipboard", mode = nvx },
  { "<esc>", "<cmd>nohlsearch<CR><esc>", desc = "Clear search on escape" },
  { "<return>", "<cmd>nohlsearch<CR><return>", desc = "Clear search on return" },
  { "|", "<cmd>vsplit<cr>", desc = "Vertical Split" },
  { "\\", "<cmd>split<cr>", desc = "Horizontal Split" },

  -- Buffers
  { "<leader>b", "<cmd>b#<cr>", desc = "Switch to last buffer", mode = nvx },
  {
    "<leader>q",
    function()
      -- Custom close/quit
      -- * if non empty buffer, we will simply open a new empty buffer unless
      --     it is in the close always list
      -- * if empty buffer, then we will quit this buffer
      local close_always = { "quickfix", "help", "nofile" }
      if
        util.table_contains(close_always, vim.bo.buftype)
        or (vim.api.nvim_buf_line_count(0) == 1 and vim.api.nvim_buf_get_lines(0, 0, 1, -1)[1] == "")
      then
        vim.cmd("silent confirm q")
      else
        vim.cmd("enew")
      end
    end,
    desc = "Quit/Close current",
    mode = nvx,
  },
  {
    "<leader>S",
    "<cmd>set equalalways<cr><cmd>set noequalalways<cr>",
    desc = "Equalize/resize screens evenly",
    mode = nvx,
  },
  { "<C-h>", "<C-W>h", desc = "Move window left current", mode = nvx },
  { "<C-j>", "<C-W>j", desc = "Move window below current", mode = nvx },
  { "<C-k>", "<C-W>k", desc = "Move window above current", mode = nvx },
  { "<C-l>", "<C-W>l", desc = "Move window right current", mode = nvx },

  -- Tabs
  -- TODO revisit, do I even need these tab things?
  { "<leader>tn", "<cmd>tabnew<cr>", desc = "Create new tab", mode = nvx },
  { "<leader>tq", "<cmd>tabclose<cr>", desc = "Close current tab", mode = nvx },
  { "H", "<cmd>tabprevious<cr>", desc = "Move to previous tab" },
  { "L", "<cmd>tabnext<cr>", desc = "Move to next tab" },

  -- LSP/IDE/etc
  {
    "<leader>l<leader>",
    vim.lsp.buf.format,
    desc = "Reformat file",
    mode = nvx,
  },
  {
    "<leader>ld",
    vim.diagnostic.open_float,
    desc = "Show diagnostic message",
    mode = nvx,
  },
  {
    "<leader>ll",
    vim.diagnostic.setloclist,
    desc = "Show diagnostics in quickfix list",
    mode = nvx,
  },

  -- =============
  -- =============
  -- =============
  -- =============
  -- =============
  -- =============
  -- =============
  -- normal mode
  -- =============
  -- { "", "", desc = "" },

  -- { "n", "nzzzv", desc = "Next search result centered" },
  -- { "N", "Nzzzv", desc = "Previous search result centered" },
  -- { "<C-d>", "<C-d>zz", desc = "Vertical half page down and center cursor" },
  -- { "<C-u>", "<C-u>zz", desc = "Vertical half page up and center cursor" },
  { "J", "mzJ`z", desc = "Move line below onto this line" },
  { "<S-Tab>", "<C-o>", desc = "Go back <C-o>" },
  {
    "]d",
    vim.diagnostic.goto_next,
    desc = "Go to next diagnostic message",
  },
  {
    "[d",
    vim.diagnostic.goto_prev,
    desc = "Go to previous diagnostic message",
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
