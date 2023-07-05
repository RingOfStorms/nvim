local servers = {
	rust_analyzer = {
		-- rust
		-- to enable rust-analyzer settings visit:
		-- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true,
			},
			checkOnSave = {
				allFeatures = true,
				command = "clippy",
			},
		},
	},
	tsserver = {
		-- typescript/javascript
	},
	pyright = {
		-- python
	},
	lua_ls = {
		-- lua
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
	bashls = {
		-- bash
	},
	cssls = {
		-- css
	},
	cssmodules_ls = {
		-- css modules
	},
	dockerls = {
		-- docker
	},
	docker_compose_language_service = {
		-- docker compose
	},
	jsonls = {
		-- json
	},
	marksman = {
		-- markdown
	},
	taplo = {
		-- toml
	},
	yamlls = {
		-- yaml
	},
	lemminx = {
		-- xml
	},
	rnix = {
		-- Nix
	},
	ansiblels = {
		-- ansible
	},
}

-- LSP config
-- Took lots of inspiration from this kickstart lua file: https://github.com/hjr3/dotfiles/blob/main/.config/nvim/init.lua

return {
	{
		-- Autocompletion
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
	},
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
		opts = {},
	},
	{
		"williamboman/mason-lspconfig.nvim",
	},
	{ "folke/neodev.nvim", opts = {} },
	{
		"neovim/nvim-lspconfig",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function()
			local config = require("lspconfig")
			local util = require("lspconfig/util")
			local mason_lspconfig = require("mason-lspconfig")
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			-- LSP
			-- This function gets run when an LSP connects to a particular buffer.
			local on_attach = function(client, bufnr)
				local nmap = function(keys, func, desc)
					if desc then
						desc = "LSP: " .. desc
					end

					vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
				end

				nmap("<leader>lr", vim.lsp.buf.rename, "[R]ename")
				nmap("<leader>la", vim.lsp.buf.code_action, "Code [A]ction")

				nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
				nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
				nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")

				-- See `:help K` for why this keymap
				nmap("K", vim.lsp.buf.hover, "Hover Documentation")
				nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

				-- Lesser used LSP functionality
				nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				-- disable tsserver so it does not conflict with prettier
				if client.name == "tsserver" then
					client.server_capabilities.document_formatting = false
				end
			end

			-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			-- Install servers used
			mason_lspconfig.setup({
				ensure_installed = vim.tbl_keys(servers),
			})

			local flags = {
				allow_incremental_sync = true,
				debounce_text_changes = 200,
			}

			mason_lspconfig.setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({
						flags = flags,
						capabilities = capabilities,
						on_attach = on_attach,
						settings = servers[server_name],
					})
				end,
			})

			-- Completion
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete({}),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "nvim_lsp", priority = 8 },
					{ nane = "buffer", priority = 7 },
					{ name = "luasnip", priority = 6 },
					{ name = "path" },
				},
				sorting = {
					priority_weight = 1,
					comparators = {
						cmp.config.compare.locality,
						cmp.config.compare.recently_used,
						cmp.config.compare.score,
						cmp.config.compare.offset,
						cmp.config.compare.order,
					},
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
			})
		end,
	},
}
