-- Remap space as leader key
vim.keymap.set("", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

require('util').keymaps({
	n = {
    ["n"] = { "nzzzv", desc = "Next search result centered" },
    ["N"] = { "Nzzzv", desc = "Previous search result centered" },
    ["<esc>"] = { ":noh<CR><esc>", desc = "Clear search on escape" },
    ["<return>"] = {":noh<CR><return>", desc = "Clear search on return" },
		["<leader>w"] = { "<cmd>w<cr>", desc = "Save" },
		["<leader>q"] = { "<cmd>confirm q<cr>", desc = "Quit" },
		["|"] = { "<cmd>vsplit<cr>", desc = "Vertical Split" },
		["\\"] = { "<cmd>split<cr>", desc = "Horizontal Split" },
		["<C-d>"] = { "<C-d>zz", desc = "Vertical half page down and center cursor" },
		["<C-u>"] = { "<C-u>zz", desc = "Vertical half page up and center cursor" },
		["y"] = { '"*y', desc = "Copy to system clipboard" },
		["p"] = { '"*p', desc = "Paste from system clipboard" },
		["<leader>Q"] = { ":qa<CR>", desc = "Quit all" },

		-- ["<leader>,j"] = { name = " Jest Tests" },
		-- ["<leader>,jr"] = { function() require("jester").run() end, desc = "Run test under cursor" },
		-- ["<leader>,jf"] = { function() require("jester").run_file() end, desc = "Run tests for file" },
		-- ["<leader>,jl"] = { function() require("jester").run_last() end, desc = "Run last ran test" },
		-- ["<leader>lz"] = { ":LspRestart<CR>", desc = "Restart LSP Server" },
	},
	v = {
		["y"] = { '"*y', desc = "Copy to system clipboard" },
		["p"] = { '"*p', desc = "Paste from system clipboard" },
    ["J"] = { ":m '>+1<CR>gv=gv", desc = "Visually move block down"},
    ["K"] = { ":m '<-2<CR>gv=gv", desc = "Visually move block up"},
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
  x = {
    ["<leader>p"] = { '"_dP', desc = "Paste w/o copying replaced content" },
  },
})


