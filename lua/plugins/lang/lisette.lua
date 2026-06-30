-- Lisette language support: https://github.com/ivov/lisette
--
-- Upstream ships its nvim runtime under `editors/nvim/` (ftdetect, ftplugin,
-- lsp/, queries) and the tree-sitter grammar under `editors/tree-sitter-lisette/`.
-- The upstream `plugin/lisette.lua` auto-compiles the parser into the plugin
-- directory, but on nix that path is the read-only store. So we replicate its
-- tiny bit of logic here, compiling the parser into a writable cache dir.
--
-- The `lis` LSP binary is expected to come from the project devShell (direnv);
-- the warning for missing `lis` is wired in lua/plugins/lang/lsp.lua via the
-- `expected_lsp_for_filetype` table.
return {
	"ivov/lisette",
	ft = "lisette",
	-- Match `.lis` files even before the plugin is loaded so `ft = "lisette"`
	-- triggers correctly on first open.
	init = function()
		vim.filetype.add({
			extension = {
				lis = "lisette",
			},
		})
	end,
	config = function(plugin)
		local nvim_dir = plugin.dir .. "/editors/nvim"
		local parser_src = plugin.dir .. "/editors/tree-sitter-lisette/src"

		-- Make queries, lsp/, ftplugin/, ftdetect/ discoverable.
		vim.opt.rtp:prepend(nvim_dir)

		-- Compile the tree-sitter parser into a writable cache dir, since
		-- `plugin.dir` may be the read-only nix store.
		local cache_dir = vim.fn.stdpath("cache") .. "/lisette"
		local parser_so = cache_dir .. "/lisette.so"

		if vim.fn.filereadable(parser_so) == 0 and vim.fn.isdirectory(parser_src) == 1 then
			vim.fn.mkdir(cache_dir, "p")
			if vim.fn.executable("cc") == 1 then
				local result = vim.fn.system({
					"cc",
					"-o",
					parser_so,
					"-I",
					parser_src,
					parser_src .. "/parser.c",
					parser_src .. "/scanner.c",
					"-shared",
					"-Os",
					"-fPIC",
				})
				if vim.v.shell_error ~= 0 then
					vim.notify("Failed to compile Lisette tree-sitter parser:\n" .. result, vim.log.levels.WARN)
				end
			else
				vim.notify("`cc` not found on PATH; skipping Lisette tree-sitter parser build.", vim.log.levels.WARN)
			end
		end

		if vim.fn.filereadable(parser_so) == 1 then
			vim.treesitter.language.add("lisette", { path = parser_so })
		end

		vim.lsp.enable("lisette")
	end,
}
