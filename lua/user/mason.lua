return {
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
