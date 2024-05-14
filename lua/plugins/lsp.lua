return {
	-- LSP helper plugins for various languages
	{ "folke/neodev.nvim", event = { "BufRead *.lua", "BufRead *.vim" }, opts = {}, main = "neodev" },
	{ "mrcjkb/rustaceanvim", lazy = false }, -- uses ftplugins to enable itself lazily already
	-- TODO add some hotkeys for opening the popup menus on crates
	{ "Saecki/crates.nvim", event = "BufRead Cargo.toml", tag = "stable", opts = {}, main = "crates" },
	{
		"neovim/nvim-lspconfig",
		event = "BufEnter",
		dependencies = {
			{
				"lvimuser/lsp-inlayhints.nvim",
				init = function()
					vim.api.nvim_create_augroup("LspAttach_inlayhints", { clear = true })
					vim.api.nvim_create_autocmd("LspAttach", {
						group = "LspAttach_inlayhints",
						callback = function(args)
							if not (args.data and args.data.client_id) then
								return
							end

							local bufnr = args.buf
							local client = vim.lsp.get_client_by_id(args.data.client_id)
							require("lsp-inlayhints").on_attach(client, bufnr)
						end,
					})
				end,
				opts = {
					type_hints = { prefix = " ::" },
				},
				main = "lsp-inlayhints",
			},
			-- Automatically install LSPs and related tools to stdpath for Neovim
			{ "williamboman/mason.nvim", enabled = not NIX, config = true }, -- NOTE: Must be loaded before dependants
			{ "williamboman/mason-lspconfig.nvim", enabled = not NIX },
			{ "WhoIsSethDaniel/mason-tool-installer.nvim", enabled = not NIX },
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("myconfig-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					map("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
					map("gr", require("telescope.builtin").lsp_references, "Goto References")
					map("gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")
					map("<leader>lr", vim.lsp.buf.rename, "Rename")
					map("<leader>la", vim.lsp.buf.code_action, "Code Action")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("gD", vim.lsp.buf.declaration, "Goto Declaration")
				end,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("myconfig-lsp-detach", { clear = true }),
				callback = function(event)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "myconfig-lsp-highlight", buffer = event.buf })
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			U.safeRequire("cmp_nvim_lsp", function(c)
				capabilities = vim.tbl_deep_extend("force", capabilities, c.default_capabilities())
			end)

			-- TODO finish porting over lsp configs: https://github.com/RingOfStorms/nvim/blob/master/lua/plugins/lsp.lua
			local servers = {
				-- Some languages (like typescript) have entire language plugins that can be useful:
				--    https://github.com/pmizio/typescript-tools.nvim
				--
				-- But for many setups, the LSP (`tsserver`) will work just fine
				-- Note that `rust-analyzer` is done via mrcjkb/rustaceanvim plugin above, do not register it here.
				lua_ls = {
					settings = {
						Lua = {
							runtime = {
								-- Tell the language server which version of Lua you're using
								-- (most likely LuaJIT in the case of Neovim)
								version = "LuaJIT",
							},
							completion = {
								callSnippet = "Replace",
							},
							workspace = {
								checkThirdParty = false,
								library = {
									vim.env.VIMRUNTIME,
									vim.api.nvim_get_runtime_file("", true),
									vim.fn.expand("$VIMRUNTIME/lua"),
									vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
								},
								telemetry = { enable = false },
								diagnostics = {
									globals = {
										"vim",
										"require",
										"NIX",
										"U",
										-- Hammerspoon for macos
										"hs",
									},
								},
							},
						},
					},
				},
				nil_ls = {},
				v_analyzer = { filetypes = { "vlang", "v", "vsh", "vv" } },
				tsserver = {
					-- typescript/javascript
					implicitProjectConfiguration = {
						checkJs = true,
					},
				},
				tailwindcss = {
					-- tailwind css
					-- https://www.tailwind-variants.org/docs/getting-started#intellisense-setup-optional
					tailwindCSS = {
						experimental = {
							classRegex = {
								{ "tv\\((([^()]*|\\([^()]*\\))*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
							},
						},
					},
				},
				cssls = {
					-- css
				},
				jsonls = {
					-- json
				},
				pyright = {
					-- python
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
			}
			if NIX then
				local lsp_servers = vim.tbl_keys(servers or {})
				for _, server_name in ipairs(lsp_servers) do
					local server_opts = servers[server_name] or {}
					require("lspconfig")[server_name].setup(server_opts)
				end
			else
				-- TODO test this out on a non nix setup...
				require("mason").setup()
				local ensure_installed = vim.tbl_keys(servers or {})
				vim.list_extend(ensure_installed, {
					"stylua", -- Used to format Lua code TODO come back to this, more about linter/formatter configs
				})
				require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
				require("mason-lspconfig").setup({
					handlers = {
						function(server_name)
							local server = servers[server_name] or {}
							server.capabilities =
								vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
							require("lspconfig")[server_name].setup(server)
						end,
					},
				})
			end
		end,
	},
}
