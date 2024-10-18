vim.g.rustaceanvim = {
	tools = {
		enable_clippy = true,
		enable_nextest = true,
		reload_workspace_from_cargo_toml = true,
	},
	server = {
		-- cmd = { "nix", "run", "nixpkgs#rust-analyzer" },
	},
}

return {
	"mrcjkb/rustaceanvim",
	version = "^5",
	lazy = false, -- already lazy
	ft = { "rust" },
	keys = {},
	command = "RustLsp",
}
