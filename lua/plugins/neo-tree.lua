return {
	"nvim-neo-tree/neo-tree.nvim",
	commit = "e5594d53986b34e584e8afe2ea6ad99d6f6d2105",
	dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
	cmd = "Neotree",
	init = function() vim.g.neo_tree_remove_legacy_commands = true end,
	pin = true,
	tag = '2.56',
	opts = {
		auto_clean_after_session_restore = true,
		close_if_last_window = true,
		sources = { "filesystem" },
		filesystem = {
			follow_current_file = true,
			group_empty_dirs = true,
			filtered_items = {
				visible = true,
				hide_dotfiles = false,
				hide_gitignored = false,
				hide_by_name = {
					".DS_Store",
				},
			},
		},
		nesting_rules = {
			["ts"] = { ".cjs", ".cjs.map", ".d.ts", ".d.ts.map", ".js", ".js.map", ".mjs", ".mjs.map", ".test.ts" },
			["js"] = { ".cjs", ".cjs.map", ".d.js", ".d.js.map", ".js", ".js.map", ".mjs", ".mjs.map", ".test.js" },
			["tsx"] = { ".d.ts", ".d.ts.map", ".js;", ".js.map;", ".jsx;", ".jsx.map;", ".module.scss;", ".svg" },
			["scss"] = { ".css", ".css.map" },
		},
	},
	keys = {
		{ "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle Explorer" },
		{ "<leader>o",function()
			if vim.bo.filetype == "neo-tree" then
				vim.cmd.wincmd "p"
			else
				vim.cmd.Neotree "focus"
			end
		end , desc = "Toggle Explorer Focus" },
	},
}

