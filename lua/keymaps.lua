-- Remap space as leader key
vim.keymap.set("", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
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
		["<Leader>p"] = { '"*p', desc = "Paste from system clipboard" },
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
				vim.lsp.buf.format()
			end,
			desc = "Reformat file",
		},
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
		["<leader>lz"] = { ":LspRestart<CR>", desc = "Restart LSP Server" },
	},
	v = {
		["y"] = { '"*y', desc = "Copy to system clipboard" },
		["p"] = { '"*p', desc = "Paste from system clipboard" },
		["J"] = { ":m '>+1<CR>gv=gv", desc = "Visually move block down" },
		["K"] = { ":m '<-2<CR>gv=gv", desc = "Visually move block up" },
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
		["<C-r"] = { '"hy:%s/<C-r>h//g<left><left>', desc = "Replace current selection" },
	},
	t = {
		["<Esc>"] = { "<C-\\><C-n>", desc = "Escape the terminal" },
	},
})
