-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- global status line
vim.opt.laststatus = 3

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- allow use of mouse
vim.opt.mouse = "a"

-- Decrease update time
vim.opt.updatetime = 250
-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- line numbering, relative
vim.opt.number = true
vim.opt.relativenumber = true

-- Highlights the results of previous search, which is annoying when we are done searching
vim.opt.hlsearch = false

-- Wrap lines in files
vim.opt.wrap = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- preseve indentation of virtual wrapped lines
vim.opt.breakindent = true

-- be smart with indents
vim.opt.smartindent = true

-- set tab length
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Dont use swap files, use undotree
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.undofile = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "│ ", trail = "·", nbsp = "␣", eol = "↴" }

-- Search settings
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Preview substitutions live, as you type
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- split to the right or below always
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Set completeopt to have a better completion experience
vim.opt.completeopt = "menu,menuone,noinsert"
vim.diagnostic.config({
	float = { border = "single" },
})

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Turn on new diff
vim.opt.diffopt:append("linematch:20")

-- Don't resize panels when closing something it is annoying
vim.opt.equalalways = false

-- enable colors for opacity changes
vim.opt.termguicolors = true
