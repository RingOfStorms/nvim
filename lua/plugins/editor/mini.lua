-- mini.nvim - Collection of minimal, fast, and composable Lua modules
-- Replaces: vim-surround, mini.comment, nvim-ts-context-commentstring
return {
	"echasnovski/mini.nvim",
	event = "VeryLazy",
	config = function()
		-- Surround: Add/delete/replace surroundings (brackets, quotes, etc.)
		-- Mappings: gsa (add), gsd (delete), gsr (replace), gsf (find), gsF (find_left)
		require("mini.surround").setup({
			mappings = {
				add = "gsa", -- Add surrounding in Normal and Visual modes
				delete = "gsd", -- Delete surrounding
				replace = "gsr", -- Replace surrounding
				find = "gsf", -- Find surrounding (to the right)
				find_left = "gsF", -- Find surrounding (to the left)
				highlight = "gsh", -- Highlight surrounding
				update_n_lines = "gsn", -- Update `n_lines`
			},
		})

		-- Native Neovim 0.11+ commenting (`gc` / `gcc`) handles Treesitter injected languages automatically
		vim.keymap.set("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment on line" })
		vim.keymap.set("x", "<leader>/", "gc", { remap = true, desc = "Toggle comment on selection" })
	end,
}
