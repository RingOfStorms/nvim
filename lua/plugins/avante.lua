return {
	"yetone/avante.nvim",
	dependencies = (function()
		local deps = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			-- {
			--   "HakonHarnes/img-clip.nvim",
			--   event = "VeryLazy",
			--   opts = {
			--     default = {
			--       embed_image_as_base64 = false,
			--       prompt_for_file_name = false,
			--       drag_and_drop = {
			--         insert_mode = true,
			--       },
			--       use_absolute_path = true,
			--     },
			--   },
			-- },
		}
		-- Only add copilot if ANTHROPIC_API_KEY is not set
		if os.getenv("ANTHROPIC_API_KEY") == nil then
			table.insert(deps, "zbirenbaum/copilot.lua")
		end
		return deps
	end)(),
	event = "VeryLazy",
	build = function()
		if not NIX then
			vim.fn.system("make")
		end
	end,
	lazy = false,
	opts = function()
		local provider = os.getenv("ANTHROPIC_API_KEY") and "claude" or "copilot"

		return {
			provider = provider,
			auto_suggestions_provider = provider,
			hints = { enabled = false },
			behavior = {
				auto_suggestions = true,
				auto_set_keymaps = false,
				support_paste_from_clipboard = true,
				auto_apply_diff_after_generation = false,
				minimize_diff = true,
			},
			windows = {
				position = "top",
				input = { prefix = "" },
			},
			mappings = {
				ask = "<nop>",
				edit = "<nop>",
				refresh = "<leader><leader>r",
				focus = "<leader><leader>f",
				toggle = {
					default = "<leader><leader>c",
					debug = "<nop>",
					hint = "<nop>",
					suggestion = "<leader><leader>S",
					repomap = "<leader><leader>R",
				},
			},
		}
	end,
	config = function(_, opts)
		require("avante_lib").load()
		require("avante").setup(opts)
	end,
	keys = {
		{
			"<leader><leader>c",
			"<cmd>AvanteToggle<cr>",
			desc = "Avante - Toggle Chat",
			mode = { "n", "v", "x" },
		},
		{
			"<leader><leader>e",
			"<cmd>AvanteEdit<cr>",
			desc = "Avante - Edit Selection",
			mode = { "v", "x" },
		},
		{
			"<leader><leader>e",
			function()
				vim.cmd("normal! ggVG")
				vim.cmd("AvanteEdit")
			end,
			desc = "Avante - Edit File",
			mode = { "n" },
		},
	},
}
