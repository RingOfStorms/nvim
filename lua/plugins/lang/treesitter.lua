return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	dependencies = { "windwp/nvim-ts-autotag" },
	lazy = false,
		init = function()
			if not NIX and vim.fn.executable("tree-sitter") ~= 1 then
				vim.notify(
					"tree-sitter CLI not found; parsers will not be installed automatically.",
					vim.log.levels.WARN
				)
			end
		end,
	config = function()
		-- The new nvim-treesitter has queries under runtime/queries/
		-- We need to add this to runtimepath for vim.treesitter to find them
		local ts_path = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter"
		if NIX then
			-- Find the nvim-treesitter plugin path in nix store
			for _, p in ipairs(vim.api.nvim_list_runtime_paths()) do
				if p:match("nvim%-treesitter%-[0-9]") or p:match("nvim%-treesitter%.[0-9]") then
					ts_path = p
					break
				end
			end
		end

		-- Add the runtime subdirectory to runtimepath if it exists and has queries
		local runtime_path = ts_path .. "/runtime"
		if vim.fn.isdirectory(runtime_path .. "/queries") == 1 then
			vim.opt.runtimepath:prepend(runtime_path)
		end

		-- In non-Nix installations parsers are compiled locally.  Recent
		-- nvim-treesitter releases require the tree-sitter CLI for this; do not
		-- start an installation that is guaranteed to fail when it is absent.
		if not NIX then
			local parsers = {
				"astro",
				"bash",
				"c",
				"css",
				"dockerfile",
				"go",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"nix",
				"python",
				"rust",
				"svelte",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			}
			if vim.fn.executable("tree-sitter") == 1 then
				require("nvim-treesitter").install(parsers)
			else
				vim.notify(
					"Tree-sitter parsers were not installed: install the tree-sitter CLI and restart Neovim.",
					vim.log.levels.WARN
				)
			end
		end

		-- MDX has no dedicated grammar in the nixpkgs treesitter bundle, so reuse
		-- the `markdown` parser for `mdx` buffers. This gives prose/code-fence
		-- highlighting (markdown_inline is auto-injected); JSX is treated as HTML.
		-- The mdx_analyzer LSP (lua/plugins/lang/lsp.lua) covers JSX intelligence.
		pcall(vim.treesitter.language.register, "markdown", "mdx")

		-- Enable treesitter highlighting via vim.treesitter.start()
		-- This works with both nix-provided parsers and installed ones
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("myconfig-treesitter-highlight", { clear = true }),
			callback = function(args)
				local bufnr = args.buf
				local ft = args.match

				-- Skip large files
				if vim.api.nvim_buf_line_count(bufnr) > 4000 then
					return
				end

				-- Skip sql (often has issues)
				if ft == "sql" then
					return
				end

				-- Enable treesitter highlighting
				-- This will silently fail if no parser is available for the filetype
				pcall(vim.treesitter.start, bufnr)
			end,
		})

		-- Configure nvim-ts-autotag if available
		U.safeRequire("nvim-ts-autotag", function(autotag)
			autotag.setup()
		end)
	end,
}
