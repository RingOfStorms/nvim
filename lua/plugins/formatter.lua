local function formatCurrent(retry)
	require("conform").format({ async = true, lsp_fallback = true }, function(err, edited)
		if edited then
			print("Formatted!")
		elseif err then
			-- Sometimes I am too fast and vim is saving from my InsertExit and this fails so
			-- I give it one retry
			if not retry and string.find(err, "concurrent modification") then
				return formatCurrent(true)
			end
			print(err)
		else
			print("Nothing to format!")
		end
	end)
end

return {
	"stevearc/conform.nvim",
	opts = {
		-- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#setup
		notify_on_error = true,
		formatters = {
			v_fmt = {
				command = "v",
        args = { "fmt" },
			},
		},
		-- Note that all these need to be available at runtime, add them to flake.nix#runtimeDependencies
		formatters_by_ft = {
			lua = { "stylua" },
			nix = { "nixfmt" },
			vlang = { "v_fmt" },
			typescript = { { "prettierd", "prettier" }, "rustywind" },
			typescriptreact = { { "prettierd", "prettier" }, "rustywind" },
			javascript = { { "prettierd", "prettier" }, "rustywind" },
			javascriptreact = { { "prettierd", "prettier" }, "rustywind" },

			-- TODO revisit these I'd like to use them but they are not in nixpkgs yet
			-- https://nixos.org/guides/nix-pills/
			-- markdown = { "mdslw", "mdsf"},
			markdown = { "markdownlint-cli2" },
			-- rust = { "rustfmt" },
		},
	},
	keys = {
		{
			"<leader>l<leader>",
			formatCurrent,
			mode = { "n", "v", "x" },
			desc = "Format buffer",
		},
	},
}
