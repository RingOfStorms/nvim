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
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		{
			"zbirenbaum/copilot.lua",
			cmd = "Copilot",
			event = "InsertEnter",
			opts = {},
			main = "copilot",
		},
		{ "zbirenbaum/copilot-cmp", opts = {}, main = "copilot_cmp" },
		{
			"CopilotC-Nvim/CopilotChat.nvim",
			branch = "canary",
			dependencies = {
				{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
				{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
			},
			opts = {
				chat_autocomplete = true,
				mappings = {
					complete = {
						insert = "",
					},
				},
				window = {
					layout = "float",
					relative = "cursor",
					width = 1,
					height = 0.4,
					row = 1,
				},
			},
			keys = {
				{
					"<leader>ch",
					function()
						local actions = require("CopilotChat.actions")
						require("CopilotChat.integrations.telescope").pick(actions.help_actions())
					end,
					desc = "CopilotChat - Help actions",
					mode = { "n", "v", "x" },
				},
				{
					"<leader>cp",
					function()
						local actions = require("CopilotChat.actions")
						require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
					end,
					desc = "CopilotChat - Prompt actions",
					mode = { "n", "v", "x" },
				},
				{
					"<leader>cq",
					function()
						local input = vim.fn.input("Quick Chat: ")
						if input ~= "" then
							require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
						end
					end,
					desc = "CopilotChat - Quick chat",
					mode = { "n", "v", "x" },
				},
				{
					"<leader>cc",
					function()
						require("CopilotChat").toggle()
					end,
					desc = "CopilotChat - Toggle",
					mode = { "n", "v", "x" },
				},
			},
			-- See Commands section for default commands if you want to lazy load on them
		},
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
					-- keyword_length = 1,
					-- filter = function(keyword)
					--   -- Check if keyword length is some number and not just whitespace
					--   if #keyword < 2 or keyword:match("^%s*$") then
					--     return false
					--   end
					--   return true
					-- end,
					-- max_item_count = 3,
				},
				{ name = "nvim_lsp", priority = 8, max_item_count = 100 },
				{ name = "luasnip", priority = 7, max_item_count = 5 },
				-- This source provides file path completions, helping you to complete file paths in your code
				{ name = "path", priority = 7, max_item_count = 3 },
				-- This source provides completion items from the current buffer, meaning it suggests words that have already been typed in the same file.
				{ name = "buffer", priority = 6, max_item_count = 5 },
				-- Rust crates.io integration
				{ name = "crates" },
			},
		})
	end,
}
