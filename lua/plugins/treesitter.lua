return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = { "windwp/nvim-ts-autotag" },
	lazy = false,
	build = ":TSUpdate",
	init = function()
		U.cmd_executable("tree-sitter", {
			[false] = function()
				vim.notify("tree-sitter not installed, code syntax will be broken.", 2)
			end,
		})
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

		-- In non-nix mode, install parsers
		if not NIX then
			local ts = require("nvim-treesitter")
			if ts.install then
				ts.install({
					"bash", "c", "css", "dockerfile", "go", "html", "javascript",
					"json", "lua", "markdown", "markdown_inline", "nix", "python",
					"rust", "svelte", "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
				})
			end
		end

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
