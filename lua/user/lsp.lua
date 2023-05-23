return {
	{
		"b0o/SchemaStore.nvim",
		commit = "15f37630d3abfb98607dd8e4625b731a8558b96d",
	},
	{
    "folke/neodev.nvim",
		commit = "2daabebac1b0b2ab7abba298c1a8f07a542866a6",
    opts = {
      override = function(root_dir, library)
        for _, astronvim_config in ipairs(astronvim.supported_configs) do
          if root_dir:match(astronvim_config) then
            library.plugins = true
            break
          end
        end
        vim.b.neodev_enabled = library.enabled
      end,
    },
  },
	{
		"neovim/nvim-lspconfig",
		commit = "1c13e529bd5683b54a39b633a560d2f00fcb25af",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
		}
	}
}
