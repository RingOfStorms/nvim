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

U.keymaps({
  -- Basic
  { "<left>", '<cmd>echo "use h/j/k/l to move!"<cr>', mode = nvx },
  { "<right>", '<cmd>echo "use h/j/k/l to move!"<cr>', mode = nvx },
  { "<up>", '<cmd>echo "use h/j/k/l to move!"<cr>', mode = nvx },
  { "<down>", '<cmd>echo "use h/j/k/l to move!"<cr>', mode = nvx },
  { ";", ":", desc = "No shift to enter command mode with semicolon. Alias ; to :", mode = nvx },
  { "<leader>Q", "<nop>", mode = nvx }, -- don't do normal Q quit
  { "<leader>a", "<esc>ggVG", desc = "Select all", mode = nvx },
  { "Q", "<cmd>SessionSave<cr><cmd>qa!<cr>", desc = "Quit all", mode = nvx },
  { "<leader>y", '"+y', desc = "Copy to system clipboard", mode = nvx },
  { "<leader>p", '"+p', desc = "Paste from system clipboard", mode = nvx },
  { "<esc>", "<cmd>nohlsearch<cr><esc>", desc = "Clear search on escape" },
  { "<return>", "<cmd>nohlsearch<cr><return>", desc = "Clear search on return" },
  { "|", "<cmd>vsplit<cr>", desc = "Vertical Split" },
  { "\\", "<cmd>split<cr>", desc = "Horizontal Split" },
  { "<S-Tab>", "<C-o>", desc = "Go back <C-o>" },
  {
    "J",
    ":m '>+1<cr>gv=gv",
    desc = "Visually move block down",
    mode = "v",
  },
  {
    "K",
    ":m '<-2<cr>gv=gv",
    desc = "Visually move block up",
    mode = "v",
  },
  { "<Esc>", "<C-\\><C-n>", desc = "Escape the terminal", mode = "t" },

  -- Buffers
  { "<leader>b", "<cmd>b#<cr>", desc = "Switch to last buffer", mode = nvx },
  {
    "<leader>q",
    function()
      -- Custom close/quit
      -- * if non empty buffer, we will simply open a new empty buffer unless
      --     it is in the close always list
      -- * if empty buffer, then we will quit this buffer
      local close_always = { "quickfix", "help", "nofile", "noice", "httpResult" }
      if
        U.table_contains(close_always, vim.bo.buftype)
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

  -- Editor
  { "J", "mzJ`z", desc = "Move line below onto this line" },
  { -- TODO stay here, are these already mapped?
    "]d",
    vim.diagnostic.goto_next,
    desc = "Go to next diagnostic message",
  },
  {
    "[d",
    vim.diagnostic.goto_prev,
    desc = "Go to previous diagnostic message",
  },
  { ">", "> gv", desc = "Indent selection", mode = "v" },
  { "<", "< gv", desc = "Outdent selection", mode = "v" },
  { "p", '"_dP', desc = "Paste without yanking replaced content", mode = "v" },
  -- TODO  take <leader>r from http requests?
  { "<C-r>", '"hy:%s/<C-r>h//g<left><left>', desc = "Replace current selection", mode = "v" },
  { "<C-k>", "<Up>", desc = "Up", mode = { "i", "c" }, desc = "Movements in insert/command mode" },
  { "<C-j>", "<Down>", desc = "Down", mode = { "i", "c" }, desc = "Movements in insert/command mode" },
  { "<C-h>", "<Left>", desc = "Left", mode = { "i", "c" }, desc = "Movements in insert/command mode" },
  { "<C-l>", "<Right>", desc = "Right", mode = { "i", "c" }, desc = "Movements in insert/command mode" },
  { "<C-4>", "<End>", desc = "End", mode = { "i", "c" }, desc = "Movements in insert/command mode" },
  { "<C-6>", "<Home>", desc = "Home", mode = { "i", "c" }, desc = "Movements in insert/command mode" },

  -- Tabs
  -- TODO revisit, do I even need these tab things?
  { "<leader>tn", "<cmd>tabnew<cr>", desc = "Create new tab", mode = nvx },
  { "<leader>tq", "<cmd>tabclose<cr>", desc = "Close current tab", mode = nvx },
  { "H", "<cmd>tabprevious<cr>", desc = "Move to previous tab" },
  { "L", "<cmd>tabnext<cr>", desc = "Move to next tab" },

  -- LSP/IDE/etc TODO move to lsp config file
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
})
