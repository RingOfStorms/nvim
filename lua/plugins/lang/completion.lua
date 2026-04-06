-- Completion engine using blink.cmp
-- Replaces nvim-cmp + cmp-nvim-lsp + cmp-buffer + cmp-path + cmp_luasnip + LuaSnip
return {
	"saghen/blink.cmp",
	event = "InsertEnter",
	version = "1.*",
	dependencies = {
		"rafamadriz/friendly-snippets",
	},
	---@module "blink.cmp"
	---@type blink.cmp.Config
	opts = {
		keymap = {
			["<C-j>"] = { "select_next", "fallback" },
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-y>"] = { "accept", "fallback" },
			["<C-c>"] = { "show", "fallback" },
			["<C-u>"] = { "scroll_documentation_up", "fallback" },
			["<C-d>"] = { "scroll_documentation_down", "fallback" },
			["<C-e>"] = { "cancel", "fallback" },
		},
		appearance = {
			nerd_font_variant = "mono",
		},
		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
				window = { border = "single" },
			},
			menu = {
				border = "single",
			},
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
		-- Use Rust fuzzy matcher when available, fall back to Lua
		fuzzy = {
			implementation = "prefer_rust",
		},
	},
}
