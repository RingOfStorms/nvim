return {
	"yetone/avante.nvim",
	dependencies = (function()
		local deps = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			-- {
			--   -- support for image pasting
			--   "HakonHarnes/img-clip.nvim",
			--   event = "VeryLazy",
			--   opts = {
			--     -- recommended settings
			--     default = {
			--       embed_image_as_base64 = false,
			--       prompt_for_file_name = false,
			--       drag_and_drop =
			--         insert_mode = true,
			--       },
			--       -- required for Windows users
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
		-- TODO does this actually work? I still dont have full non nix support tested for this config.
		if not NIX then
			vim.cmd("make")
		end
	end,
	lazy = false,
	opts = function()
		local provider
		if os.getenv("ANTHROPIC_API_KEY") then
			provider = "claude"
		else
			provider = "copilot"
		end

		return {
			provider = provider,
			auto_suggestions_provider = provider,
			hints = { enabled = false },
			behavior = {
				auto_suggestions = true, -- Experimental stage
				auto_set_keymaps = false,
				support_paste_from_clipboard = true,
				auto_apply_diff_after_generation = false,
			},
			windows = {
				position = "top",
				input = {
					prefix = "",
				},
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
			"<esc>ggVG<cmd>AvanteEdit<cr>",
			desc = "Avante - Edit File",
			mode = { "n" },
		},
	},
}
