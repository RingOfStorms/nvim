return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = { "windwp/nvim-ts-autotag" },
	lazy = false, -- nvim-treesitter does not support lazy-loading per docs
	build = ":TSUpdate",
	init = function()
		U.cmd_executable("tree-sitter", {
			[false] = function()
				vim.notify("tree-sitter not installed, code syntax will be broken.", 2)
			end,
		})
	end,
	config = function()
		-- New nvim-treesitter API (post-rewrite)
		-- Setup is optional and only needed for non-default install directory
		local ts = require("nvim-treesitter")

		-- In nix mode, parsers are provided by the nix store, no installation needed
		if not NIX then
			-- Install common parsers (async)
			ts.install({
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
			})
		end

		-- Enable treesitter highlighting for all filetypes
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
				pcall(vim.treesitter.start, bufnr)
			end,
		})

		-- Enable treesitter-based folding
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("myconfig-treesitter-fold", { clear = true }),
			callback = function(args)
				local win = vim.api.nvim_get_current_win()
				vim.wo[win][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.wo[win][0].foldmethod = "expr"
				vim.wo[win][0].foldenable = false -- Start with folds open
			end,
		})
	end,
}
