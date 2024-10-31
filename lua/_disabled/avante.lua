return {
	"yetone/avante.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		-- {
		--   -- support for image pasting
		--   "HakonHarnes/img-clip.nvim",
		--   event = "VeryLazy",
		--   opts = {
		--     -- recommended settings
		--     default = {
		--       embed_image_as_base64 = false,
		--       prompt_for_file_name = false,
		--       drag_and_drop = {
		--         insert_mode = true,
		--       },
		--       -- required for Windows users
		--       use_absolute_path = true,
		--     },
		--   },
		-- },
	},
	event = "VeryLazy",
	lazy = false,
	opts = {
		provider = "claude",
	},
	config = function(_, opts)
		require("avante_lib").load()
		require("avante").setup(opts)
	end,
}
