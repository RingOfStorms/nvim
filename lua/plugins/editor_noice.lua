return {
	"folke/noice.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
		{ "nvim-telescope/telescope.nvim", optional = true },
	},
	event = "VeryLazy",
	opts = {
		messages = {
			view = "mini", -- default view for messages
			view_error = "notify", -- view for errors
			view_warn = "mini", -- view for warnings
			view_history = "messages", -- view for :messages
			view_search = false, -- view for search count messages. Set to `false` to disable
		},
		lsp = {
			-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
			},
			-- I had an issue with auto_open kicking me out of insert mode when entering insert mode
			signature = { auto_open = { trigger = false } },
		},
	},
	config = function(_, opts)
		require("noice").setup(opts)
		U.safeRequire("telescope", function(t)
			t.load_extension("noice")
		end)
	end,
}
