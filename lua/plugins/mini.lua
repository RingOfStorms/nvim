-- mini.nvim - Collection of minimal, fast, and composable Lua modules
-- Replaces: vim-surround, Comment.nvim, nvim-ts-context-commentstring
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

		-- Comment: Smart commenting with treesitter support
		-- gc{motion} in Normal, gc in Visual to toggle comments
		require("mini.comment").setup({
			-- Hooks for custom comment handling (e.g., JSX/TSX)
			options = {
				custom_commentstring = function()
					-- Use treesitter commentstring if available
					return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
				end,
			},
		})



		-- Enhanced text objects: Better text objects for quotes, brackets, etc.
		-- Adds: aq/iq (quotes), ab/ib (brackets), af/if (function), etc.
		require("mini.ai").setup()

		-- Preserve <leader>/ for comment toggle (matches old Comment.nvim binding)
		vim.keymap.set("n", "<leader>/", function()
			return require("mini.comment").operator() .. "_"
		end, { expr = true, desc = "Toggle comment on line" })

		vim.keymap.set("x", "<leader>/", function()
			return require("mini.comment").operator()
		end, { expr = true, desc = "Toggle comment on selection" })
	end,
	dependencies = {
		-- Keep ts-context-commentstring for JSX/TSX/embedded languages
		{
			"JoosepAlviste/nvim-ts-context-commentstring",
			lazy = true,
			init = function()
				-- Skip backwards compatibility routines
				vim.g.skip_ts_context_commentstring_module = true
			end,
			opts = {
				enable_autocmd = false, -- mini.comment handles this
			},
		},
	},
}
