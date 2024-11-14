return {
	-- cond = false,
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
	build = function()
		-- TODO does this actually work? I still dont have full non nix support tested for this config.
		if not NIX then
			vim.cmd("make")
		end
	end,
	lazy = false,
	opts = {
		provider = "claude",
		behavior = {
			-- auto_suggestions = true, -- Experimental stage
			auto_set_keymaps = false,
			support_paste_from_clipboard = true,
		},
	},
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
			"<leader><leader>r",
			"<cmd>AvanteRefresh<cr>",
			desc = "Avante - Refresh",
			mode = { "n", "v", "x" },
		},
		{
			"<leader><leader>f",
			"<cmd>AvanteFocus<cr>",
			desc = "CopilotChat - Quick chat",
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
