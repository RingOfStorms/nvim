return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		-- Snippet Engine & its associated nvim-cmp source
		{
			"L3MON4D3/LuaSnip",
			dependencies = {
				{
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
					end,
				},
			},
		},
		"saadparwaiz1/cmp_luasnip",

		-- Adds other completion capabilities.
		--  nvim-cmp does not ship with all sources by default. They are split
		--  into multiple repos for maintenance purposes.
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		{
			"zbirenbaum/copilot.lua",
			cmd = "Copilot",
			event = "InsertEnter",
			opts = {
				-- suggestion = { enabled = false, auto_trigger = false },
				-- panel = { enabled = false, auto_trigger = false },
			},
			main = "copilot",
		},
		{ "zbirenbaum/copilot-cmp", opts = {}, main = "copilot_cmp" },
	},
	config = function()
		-- See `:help cmp`
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		luasnip.config.setup({})

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			completion = { completeopt = "menu,menuone,noinsert" },
			mapping = cmp.mapping.preset.insert({
				-- Scroll the documentation window [b]ack / [f]orward
				["<C-u>"] = cmp.mapping.scroll_docs(-4),
				["<C-d>"] = cmp.mapping.scroll_docs(4),
				["<esc>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.abort()
						if cmp.get_active_entry() == nil then
							-- TODO this is still being weird... if I go into active entry then back up and press esc it causes havoc
							fallback()
						end
					else
						fallback()
					end
				end),
				-- ["<esc>"] = cmp.mapping.abort(),

				-- Select the [n]ext item
				["<C-j>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				-- Select the [p]revious item
				["<C-k>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-c>"] = cmp.mapping.complete({}),
			}),
			sources = {
				{
					name = "copilot",
					priority = 9,
					keyword_length = 1,
					filter = function(keyword)
						-- Check if keyword length is some number and not just whitespace
						if #keyword < 2 or keyword:match("^%s*$") then
							return false
						end
						return true
					end,
				},
				{ name = "nvim_lsp", priority = 8, max_item_count = 100 },
				{ name = "luasnip", priority = 7 },
				-- This source provides file path completions, helping you to complete file paths in your code
				{ name = "path", priority = 7 },
				-- This source provides completion items from the current buffer, meaning it suggests words that have already been typed in the same file.
				{ name = "buffer", priority = 6 },
				-- Rust crates.io integration
				{ name = "crates" },
			},
		})
	end,
}
