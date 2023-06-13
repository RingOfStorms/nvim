return {
	"VonHeikemen/lsp-zero.nvim",
	branch = "v2.x",
	dependencies = {
		-- LSP Support
		{ "neovim/nvim-lspconfig" },
		{
			"williamboman/mason.nvim",
			cmd = {
				"Mason",
				"MasonUpdate",
				"MasonInstall",
				"MasonInstallAll",
				"MasonUninstall",
				"MasonUninstallAll",
				"MasonLog",
			},
			build = ":MasonUpdate",
      event = "BufRead",
		},
		{ "williamboman/mason-lspconfig.nvim" },
		-- Autocompletion
		{
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",
			dependencies = {
				-- Snips
				{
					"L3MON4D3/LuaSnip",
					dependencies = "rafamadriz/friendly-snippets",
					opts = {
						history = true,
						updateevents = "TextChanged,TextChangedI",
						-- config? -- https://github.com/NvChad/NvChad/blob/v2.0/lua/plugins/configs/others.lua#L25-L50
					},
				},
				{
					"windwp/nvim-autopairs",
					opts = {
						fast_wrap = {},
						disable_filetype = { "TelescopePrompt", "vim" },
					},
					config = function(_, opts)
						require("nvim-autopairs").setup(opts)
						-- setup cmp for autopairs
						local cmp_autopairs = require("nvim-autopairs.completion.cmp")
						require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
					end,
				},
				{ "saadparwaiz1/cmp_luasnip" },
				{ "hrsh7th/cmp-nvim-lua" },
				{ "hrsh7th/cmp-nvim-lsp" },
				{ "hrsh7th/cmp-buffer" },
				{ "hrsh7th/cmp-path" },
				{ "hrsh7th/cmp-cmdline" },
			},
		},
	},
	config = function()
		local lsp = require("lsp-zero").preset({})
		local config = require("lspconfig")
		local util = require("lspconfig/util")


		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		capabilities = vim.tbl_deep_extend("keep", capabilities, vim.lsp.protocol.make_client_capabilities())
		capabilities.textDocument.completion.completionItem = {
			documentationFormat = { "markdown", "plaintext" },
			snippetSupport = true,
			preselectSupport = true,
			insertReplaceSupport = true,
			labelDetailsSupport = true,
			deprecatedSupport = true,
			commitCharactersSupport = true,
			tagSupport = { valueSet = { 1 } },
			resolveSupport = {
				properties = {
					"documentation",
					"detail",
					"additionalTextEdits",
				},
			},
		}

		local on_attach = function(client, bufnr)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false

			lsp.default_keymaps({ buffer = bufnr })

      local opts = { buffer = bufnr }
      local bind = function(map, cmd, mode) vim.keymap.set('n', map, cmd, opts) end

      -- diagnostics
      bind("<leader>ld", "<cmd>lua vim.diagnostic.open_float()<CR>")
      bind("<leader>[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
      bind("<leader>]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")

      bind("<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>")
		end

		lsp.on_attach(on_attach)
    local servers = {
			--      -- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
      -- lua
			"lua_ls",
      -- rust
			"rust_analyzer",
      -- ts/js | web
			"tsserver",
      "html",
			"eslint",
			"cssls",
			"cssmodules_ls",

      -- python
			"pyright",

      -- docker
			"dockerls",
			"docker_compose_language_service",
		}
		lsp.ensure_installed(servers)

    local default = require('util').spread {
      on_attach = on_attach,
			capabilities = capabilities,
    }

		config.lua_ls.setup(lsp.nvim_lua_ls())
		config.stylua.setup(default {})

		config.rust_analyzer.setup(default {})

		config.tsserver.setup(default {
					root_dir = util.root_pattern("tsconfig.json", ".git"),
		})
		config.html.setup(default {})
		config.eslint.setup(default {})
		config.deno.setup(default {})
		config.cssls.setup(default {})
		config.cssmodules_ls.setup(default {})
		config.prettier.setup(default {})

		config.pyright.setup(default {})

		lsp.setup()

    local cmp = require("cmp")
		local cmp_action = require("lsp-zero").cmp_action()

		cmp.setup({
			window = {
				documentation = cmp.config.window.bordered(),
			},
			sources = {
				{ name = "nvim_lsp", priority = 1000 },
				{ name = "luasnip", priority = 750, keyword_length = 2 },
				{ name = "buffer", priority = 500, keyword_length = 3 },
				{ nane = "nvim_lua", print = 250, keyword_length = 3 },
				{ name = "path", priority = 150, keyword_length = 3 },
				-- { name = "cmdline", priority = 50, keyword_length = 5 },
			},
			mapping = {
				["<CR>"] = cmp.mapping.confirm({ select = false }),
				["<Tab>"] = cmp_action.tab_complete(),
				["<S-Tab>"] = cmp_action.select_prev_or_fallback(),
				-- Ctrl+Space to trigger completion menu
				["<C-Space>"] = cmp.mapping.complete(),

				["<C-f>"] = cmp_action.luasnip_jump_forward(),
				["<C-b>"] = cmp_action.luasnip_jump_backward(),
			},
		})
	end,
	--  keys = {
	--    { "<leader>l", "<Nop>", desc = "LSP" },
	--  },
}
