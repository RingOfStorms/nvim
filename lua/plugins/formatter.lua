return {
	"stevearc/conform.nvim",
	opts = {
		-- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#setup
		notify_on_error = true,
    -- Note that all these need to be available at runtime, add them to flake.nix#runtimeDependencies
		formatters_by_ft = {
			lua = { "stylua" },
      nix = { "nixfmt" },
			typescript = { { "prettierd", "prettier" } },
			typescriptreact = { { "prettierd", "prettier" } },
			javascript = { { "prettierd", "prettier" } },
			javascriptreact = { { "prettierd", "prettier" } },
      -- TODO revisit these I'd like to use them but they are not in nixpkgs yet
      -- https://nixos.org/guides/nix-pills/
      -- markdown = { "mdslw", "mdsf"},
      markdown = { "markdownlint-cli2" },
		},
	},
	keys = {
		{
			"<leader>l<leader>",
			function()
				require("conform").format({ async = true, lsp_fallback = true }, function(err, edited)
					if edited then
						print("Formatted!")
					elseif err then
						print(err)
					else
						print("Nothing to format!")
					end
				end)
			end,
			mode = { "n", "v", "x" },
			desc = "Format buffer",
		},
	},
}
