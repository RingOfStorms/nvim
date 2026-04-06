vim.g.rustaceanvim = {
	tools = {
		enable_clippy = true,
		enable_nextest = true,
		reload_workspace_from_cargo_toml = true,
	},
	server = {
		-- cmd = { "nix", "run", "nixpkgs#rust-analyzer" },
	},
}

return {
	-- LSP helper plugins for various languages
	-- lazydev.nvim handles Lua/Neovim development (configured in lazydev.lua)
	-- TODO add some hotkeys for opening the popup menus on crates
	{ "Saecki/crates.nvim", event = "BufRead Cargo.toml", tag = "stable", opts = {}, main = "crates" },
	{
		"mrcjkb/rustaceanvim",
		version = "^5",
		lazy = false, -- already lazy
		ft = { "rust" },
		keys = {},
		command = "RustLsp",
	},
	{
		"neovim/nvim-lspconfig",
		event = "BufEnter",
		dependencies = {
			{ "b0o/schemastore.nvim" },
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
					map("gd", function()
						Snacks.picker.lsp_definitions()
					end, "Goto Definition")
					map("gr", function()
						Snacks.picker.lsp_references()
					end, "Goto References")
					map("gI", function()
						Snacks.picker.lsp_implementations()
					end, "Goto Implementation")
					map("<leader>lr", vim.lsp.buf.rename, "Rename")
					map("<leader>la", vim.lsp.buf.code_action, "Code Action")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("gD", vim.lsp.buf.declaration, "Goto Declaration")
				end,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("myconfig-lsp-detach", { clear = true }),
				callback = function()
					vim.lsp.buf.clear_references()
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			-- Extend capabilities with blink.cmp for better completion support
			U.safeRequire("blink.cmp", function(blink)
				capabilities = blink.get_lsp_capabilities(capabilities)
			end)
			-- Export common capabilities to all servers via vim.lsp.config('*')
			vim.lsp.config("*", { capabilities = capabilities })
			local schemastore = require("schemastore")

			local servers = {
				-- Note that `rust-analyzer` is done via mrcjkb/rustaceanvim plugin above, do not register it here.
				lua_ls = {
					settings = {
						Lua = {
							runtime = {
								version = "LuaJIT",
							},
							completion = {
								callSnippet = "Replace",
							},
							-- lazydev.nvim handles workspace library configuration
							diagnostics = {
								globals = {
									"vim",
									"require",
									"NIX",
									"U",
									"Snacks",
									-- Hammerspoon for macos
									"hs",
								},
							},
							telemetry = { enable = false },
						},
					},
				},
				gopls = {
					single_file_support = true,
				},
				nil_ls = { -- nix
				},
				ts_ls = {
					-- typescript/javascript
					implicitProjectConfiguration = {
						checkJs = true,
					},
				},
				svelte = {
					-- svelte
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
					settings = {
						json = {
							schemas = schemastore.json.schemas(),
							validate = { enable = true },
						},
					},
				},
				-- python
				pylsp = {},
				marksman = {
					-- markdown
				},
				taplo = {
					-- toml
				},
				yamlls = {
					-- yaml
					settings = {
						yaml = {
							schemas = schemastore.yaml.schemas(),
							schemaStore = {
								enable = false,
								url = "",
							},
						},
					},
				},
				lemminx = {
					-- xml
				},
			}
			-- Remove new global default keymaps added by Nvim if you prefer your own bindings
			local global_unmaps = {
				{ mode = "n", lhs = "gra" },
				{ mode = "n", lhs = "gri" },
				{ mode = "n", lhs = "grn" },
				{ mode = "n", lhs = "grr" },
				{ mode = "n", lhs = "grt" },
				{ mode = "n", lhs = "gO" },
				{ mode = "n", lhs = "K" },
				{ mode = "i", lhs = "<C-S>" },
			}
			for _, m in ipairs(global_unmaps) do
				pcall(vim.keymap.del, m.mode, m.lhs)
			end

			-- Smart LSP detection: notify user when LSP is missing for a filetype
			local expected_lsp_for_filetype = {
				rust = { name = "rust-analyzer", binary = "rust-analyzer" },
				typescript = { name = "ts_ls", binary = "typescript-language-server" },
				typescriptreact = { name = "ts_ls", binary = "typescript-language-server" },
				javascript = { name = "ts_ls", binary = "typescript-language-server" },
				javascriptreact = { name = "ts_ls", binary = "typescript-language-server" },
				python = { name = "pylsp", binary = "pylsp" },
				go = { name = "gopls", binary = "gopls" },
				svelte = { name = "svelte", binary = "svelteserver" },
				css = { name = "cssls", binary = "vscode-css-language-server" },
				html = { name = "html", binary = "vscode-html-language-server" },
				json = { name = "jsonls", binary = "vscode-json-language-server" },
				yaml = { name = "yamlls", binary = "yaml-language-server" },
				toml = { name = "taplo", binary = "taplo" },
				markdown = { name = "marksman", binary = "marksman" },
				xml = { name = "lemminx", binary = "lemminx" },
				-- lua and nix are always available from core deps
			}
			local lsp_warned = {}
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("myconfig-lsp-detect", { clear = true }),
				callback = function(args)
					local ft = args.match
					local expected = expected_lsp_for_filetype[ft]
					if expected and not lsp_warned[ft] then
						if vim.fn.executable(expected.binary) ~= 1 then
							lsp_warned[ft] = true
							vim.defer_fn(function()
								vim.notify(
									string.format(
										"LSP '%s' for %s not found.\nAdd '%s' to your project devShell.",
										expected.name,
										ft,
										expected.binary
									),
									vim.log.levels.WARN
								)
							end, 500)
						end
					end
				end,
			})

			if NIX then
				local lsp_servers = vim.tbl_keys(servers or {})
				for _, server_name in ipairs(lsp_servers) do
					local server_opts = servers[server_name] or {}
					vim.lsp.config(server_name, server_opts)
					local ok, err = pcall(function()
						vim.lsp.enable(server_name)
					end)
					if not ok then
						vim.notify(
							string.format(
								"LSP '%s' failed to start. Install it in your project devShell.\nError: %s",
								server_name,
								err
							),
							vim.log.levels.ERROR
						)
					end
				end
			else
				-- TODO test this out on a non nix setup...
				require("mason").setup()
				local ensure_installed = vim.tbl_keys(servers or {})
				vim.list_extend(ensure_installed, {
					"stylua",
				})
				require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
				require("mason-lspconfig").setup({
					handlers = {
						function(server_name)
							local server = servers[server_name] or {}
							vim.lsp.config(server_name, server)
							vim.lsp.enable(server_name)
						end,
					},
				})
			end
		end,
	},
}
