return {
	"nvim-lualine/lualine.nvim",
	--dependencies = {
	--	"RingOfStorms/lualine-lsp-progress",
	--},
	opts = {
		options = {
			theme = "codedark",
			section_separators = { left = "", right = "" },
			component_separators = "|",
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff", "diagnostics" },
			lualine_c = { "filename" },
			lualine_x = { "encoding", "filetype", "filesize" },
			lualine_y = { "searchcount", "selectioncount" },
			lualine_z = { "location" },
		},
	},
}
