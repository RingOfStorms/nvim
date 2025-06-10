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
		-- local provider = os.getenv("ANTHROPIC_API_KEY") and "claude" or "copilot"
		return {
			provider = "copilot",
			auto_suggestions_provider = "copilot",
			-- providers = {
			-- 	ollama = {
			-- 		endpoint = "http://100.64.0.6:11434/", -- Note that there is no /v1 at the end.
			-- 		model = "gemma3:12b",
			-- 	},
			-- 	ollamafast = {
			-- 		__inherited_from = "ollama",
			-- 		endpoint = "http://100.64.0.6:11434/", -- Note that there is no /v1 at the end.
			-- 		model = "gemma3:4b",
			-- 	},
			-- },
			hints = { enabled = true },
			behavior = {
				auto_suggestions = true,
				auto_set_highlight_group = true,
				auto_set_keymaps = false,
				support_paste_from_clipboard = true,
				auto_apply_diff_after_generation = false,
				minimize_diff = true,
			},
			suggestion = {
				debounce = 200,
				throttle = 200,
			},
			windows = {
				position = "right",
				wrap = true,
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
