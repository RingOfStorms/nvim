-- Scratch files
local scratch = function(extension)
  os.execute "mkdir -p ~/dev/scratches/"
  local date = os.date "%Y-%m-%dT%H:%M:%S"
  local filepath = "~/dev/scratches/scratch_" .. date .. extension
  vim.cmd("execute 'edit " .. filepath .. "'")
end

require('util').keymaps({
	n = {
    ["<leader>fsw"] = {
			function()
				require("telescope.builtin").live_grep {
					search_dirs = { "~/dev/scratches/" },
				}
			end,
			desc = "Find Words in Scratches",
		},
    ["<leader>fsf"] = {
			function()
				require("telescope.builtin").find_files{
					search_dirs = { "~/dev/scratches/" },
				}
			end,
			desc = "Find Scratches",
		},
		["<leader>s"] = { "<Nop>", desc = "Scratch File" },
		["<leader>ss"] = { function() scratch ".txt" end, desc = "New text scratch file" },
		["<leader>sn"] = { function() scratch ".json" end, desc = "New json scratch file" },
		["<leader>sm"] = { function() scratch ".md" end, desc = "New markdown scratch file" },
		["<leader>sq"] = { function() scratch ".sql" end, desc = "New sql scratch file" },
		["<leader>st"] = { function() scratch ".ts" end, desc = "New ts scratch file" },
		["<leader>sb"] = { function() scratch ".sh" end, desc = "New shell scratch file" },
		["<leader>sj"] = { function() scratch ".js" end, desc = "New js scratch file" },
	}
})

