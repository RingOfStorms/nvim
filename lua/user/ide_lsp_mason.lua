-- npm install -g cspell@latest

local output = vim.fn.system {
  "which",
  "cspell",
}
if output == nil or output == "" then
  -- if v:shell_error != 0 then
  vim.fn.system {
    "npm",
    "install",
    "-g",
    "cspell@latest",
  }
end

return {
	{
		-- universal JSON schema store, where schemas for popular JSON documents can be found.
		"b0o/SchemaStore.nvim",
		commit = "15f37630d3abfb98607dd8e4625b731a8558b96d",
	},
	{
		"neovim/nvim-lspconfig",
		commit = "1c13e529bd5683b54a39b633a560d2f00fcb25af",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
		}
	},
	-- NULL LS
	{
		"jose-elias-alvarez/null-ls.nvim",
		commit = "77e53bc3bac34cc273be8ed9eb9ab78bcf67fa48",
		opts = function(_, config)
			-- config variable is the default definitions table for the setup function call
			local null_ls = require "null-ls"

			-- Check supported formatters and linters
			-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
			-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
			config.sources = {
				-- Set a formatter
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.formatting.rustfmt,
				-- null_ls.builtins.code_actions.proselint, -- TODO looks interesting
				null_ls.builtins.code_actions.cspell.with {
					config = {
						find_json = function() return vim.fn.findfile("cspell.json", vim.fn.environ().HOME .. "/.config/nvim/lua/user/;") end,
					},
				},
				null_ls.builtins.diagnostics.cspell.with {
					extra_args = { "--config", "~/.config/nvim/lua/user/cspell.json" },
				},
			}

			config.update_in_insert = true

			return config -- return final config table
		end,
	},
	-- MASON
	{
		"williamboman/mason.nvim",
    build = ":MasonUpdate", -- :MasonUpdate updates registry contents
		commit = "08b2fd308e0107eab9f0b59d570b69089fd0b522",
		cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
      "MasonUpdate", -- AstroNvim extension here as well
      "MasonUpdateAll", -- AstroNvim specific
    },
		opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_uninstalled = "✗",
          package_pending = "⟳",
        },
      },
    },
		--config = function(_, opts)
			--require('mason').setup(opts)
			--for _, plugin in ipairs { "mason-lspconfig", "mason-null-ls", "mason-nvim-dap" } do
			--	pcall(require, plugin)
			--end
		--end
	},
  {
    "williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		commit = "c55d18f3947562e699d34d89681edbf9f0e250d3",
		cmd = { "LspInstall", "LspUninstall" },
    opts = {
      ensure_installed = { "lua_ls", "rust_analyzer", "tsserver", "pyright", "cssls", "cssmodules_ls" },
    },
  },
  {
    "jay-babu/mason-null-ls.nvim",
		commit = "54d702020bf94e4eefd357f0b738317af30217eb",
		event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    opts = {
      ensure_installed = { "prettier", "stylua", "black", "rust_fmt" },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
		commit = "c836e511e796d2b6a25ad9f164f5b25d8b9ff705",
		dependencies = {
			"williamboman/mason.nvim",
  		"mfussenegger/nvim-dap",
		},
    opts = {
      ensure_installed = { "codelldb" },
    },
  },

}
