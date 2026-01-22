-- lazydev.nvim - Faster Lua/Neovim development
-- Replaces neodev.nvim (which is archived)
return {
	"folke/lazydev.nvim",
	ft = "lua",
	opts = {
		library = {
			-- Load luv types when vim.uv is used
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		},
	},
}
