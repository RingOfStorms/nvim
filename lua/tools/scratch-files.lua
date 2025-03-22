local extensions = {
	"json",
	"sql",
	"html",
	"txt",
	"md",
	"lua",
	"css",
	"http",
	"js",
	"ts",
	"sh",
	"vim",
	"yaml",
	"toml",
	"conf",
	"nix",
	"rs",
	"py",
	"go",
	"rb",
	"java",
	"c",
	"cpp",
	"h",
	"hpp",
	"cs",
	"php",
	"pl",
	"r",
	"swift",
	"kt",
	"clj",
	"cljs",
	"hs",
	"elm",
	"erl",
	"ex",
	"exs",
	"scala",
	"groovy",
	"dart",
	"ts",
	"tsx",
	"jsx",
	"rs",
	"ml",
	"svelte",
	"svelte.ts",
	"svelte.js",
	"svg",
	"scad",
}

local xdg_data_home = os.getenv("XDG_DATA_HOME") or (os.getenv("HOME") .. "/.local/share")
local scratches_dir = xdg_data_home .. "/scratches"

-- Function to create a scratch file
local function create_scratch_file(extension)
	vim.fn.mkdir(scratches_dir, "p")

	local date = os.date("%Y_%m_%d_%H_%M_%S")
	local filename = string.format("%s/%s.%s", scratches_dir, date, extension)
	vim.cmd("edit " .. filename)
end

-- Function to prompt for file extension
local function prompt_for_extension()
	U.safeRequire("telescope", function()
		local pickers = require("telescope.pickers")
		local finders = require("telescope.finders")
		local sorters = require("telescope.config").values.generic_sorter
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")

		pickers
			.new({
				layout_strategy = "vertical",
				layout_config = {
					width = 0.3,
					height = 0.4,
					prompt_position = "top",
				},
			}, {
				prompt_title = "Choose or enter file extension",
				finder = finders.new_table({
					results = extensions,
					entry_maker = function(entry)
						return {
							value = entry,
							display = entry,
							ordinal = entry,
						}
					end,
				}),
				sorter = sorters({}),
				attach_mappings = function(prompt_bufnr, map)
					local function on_select()
						local selection = action_state.get_selected_entry()
						actions.close(prompt_bufnr)
						create_scratch_file(selection.value)
					end

					map("i", "<CR>", on_select)
					map("n", "<CR>", on_select)
					return true
				end,
			})
			:find()
	end, function()
		local extension = vim.fn.input("Enter file extension: ")
		create_scratch_file(extension)
	end)
end

-- Set up the keymap
U.keymaps({
	{
		"<leader>fsw",
		function()
			require("telescope.builtin").live_grep({
				search_dirs = { scratches_dir },
			})
		end,
		desc = "Find Words in Scratches",
	},
	{
		"<leader>fss",
		function()
			require("telescope.builtin").find_files({
				search_dirs = { scratches_dir },
			})
		end,
		desc = "Find Scratches",
	},
	{ "<leader>ss", prompt_for_extension, mode = { "n", "v", "x" }, desc = "Create a scratch file" },
})
