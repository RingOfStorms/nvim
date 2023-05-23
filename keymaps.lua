-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

local scratch = function(extension)
  os.execute "mkdir -p ~/dev/scratches/"
  local date = os.date "%Y-%m-%dT%H:%M:%S"
  local filepath = "~/dev/scratches/scratch_" .. date .. extension
  vim.cmd("execute 'edit " .. filepath .. "'")
end

local mappings = {
  n = {
		["<leader>w"] = { "<cmd>w<cr>", desc = "Save" },
		["<leader>q"] = { "<cmd>confirm q<cr>", desc = "Quit" },
		["|"] = { "<cmd>vsplit<cr>", desc = "Vertical Split" },
		["\\"] = { "<cmd>split<cr>", desc = "Horizontal Split" },
    ["<C-d>"] = { "<C-d>zz", desc = "Vertical half page down and center cursor" },
    ["<C-u>"] = { "<C-u>zz", desc = "Vertical half page up and center cursor" },
    ["y"] = { '"*y', desc = "Copy to system clipboard" },
    ["p"] = { '"*p', desc = "Paste from system clipboard" },
		-- TODO L-c to close buffer

    ["<leader>fs"] = {
      function()
        require("telescope.builtin").live_grep {
          search_dirs = { "~/dev/scratches/" },
        }
      end,
      desc = "Find words in scratches",
    },
    ["<leader>s"] = { name = " Scratch File" },
    ["<leader>ss"] = { function() scratch ".txt" end, desc = "New text scratch file" },
    ["<leader>sn"] = { function() scratch ".json" end, desc = "New json scratch file" },
    ["<leader>sq"] = { function() scratch ".sql" end, desc = "New sql scratch file" },
    ["<leader>st"] = { function() scratch ".ts" end, desc = "New ts scratch file" },
    ["<leader>sb"] = { function() scratch ".sh" end, desc = "New shell scratch file" },
    ["<leader>sj"] = { function() scratch ".js" end, desc = "New js scratch file" },

    
    ["<leader>Q"] = { ":qa<CR>", desc = "Quit all" },
    ["<leader>,"] = { name = " Misc Tools" },
    ["<leader>,c"] = { name = " Casing" },
    ["<leader>,cs"] = { ":Snek<CR>", desc = "To Snek Case" },
    ["<leader>,cc"] = { ":Camel<CR>", desc = "To Camel Case" },
    ["<leader>,cp"] = { ":CamelB<CR>", desc = "To Pascal Case" },
    ["<leader>,ck"] = { ":Kebab<CR>", desc = "To Kebab Case" },
    ["<leader>,ce"] = { ":Screm<CR>", desc = "To Screm Case" },
    ["<leader>,j"] = { name = " Jest Tests" },
    ["<leader>,jr"] = { function() require("jester").run() end, desc = "Run test under cursor" },
    ["<leader>,jf"] = { function() require("jester").run_file() end, desc = "Run tests for file" },
    ["<leader>,jl"] = { function() require("jester").run_last() end, desc = "Run last ran test" },
    ["<leader>lz"] = { ":LspRestart<CR>", desc = "Restart LSP Server" },
  },
  v = {
    ["<leader>gf"] = { ":OpenInGHFile <CR>", desc = "Open in github" },
    ["y"] = { '"*y', desc = "Copy to system clipboard" },
    ["p"] = { '"*p', desc = "Paste from system clipboard" },
    ["∆"] = {
      cmd = ":m '>+1<CR>gv=gv",
      desc = "Move the selected text up",
    },
    ["˚"] = {
      cmd = ":m '<-2<CR>gv=gv",
      desc = "Move the selected text down",
    },
    ["<leader>,"] = { name = " Misc Tools" },
    ["<leader>,c"] = { name = " Casing" },
    ["<leader>,cs"] = { ":Snek<CR>", desc = "To Snek Case" },
    ["<leader>,cc"] = { ":Camel<CR>", desc = "To Camel Case" },
    ["<leader>,cp"] = { ":CamelB<CR>", desc = "To Pascal Case" },
    ["<leader>,ck"] = { ":Kebab<CR>", desc = "To Kebab Case" },
    ["<leader>,ce"] = { ":Screm<CR>", desc = "To Screm Case" },
  },
  x = {
    ["∆"] = {
      cmd = ":m '>+1<CR>gv=gv",
      desc = "Move the selected text up",
    },
    ["˚"] = {
      desc = "Move the selected text down",
      cmd = ":m '<-2<CR>gv=gv",
    },
  },
  i = {
    ["<C-k>"] = { "<Up>", desc = "Up" },
    ["<C-j>"] = { "<Down>", desc = "Down" },
    ["<C-h>"] = { "<Left>", desc = "Left" },
    ["<C-l>"] = { "<Right>", desc = "Right" },
  },
  c = {
    ["<C-h>"] = { "<Left>", desc = "Left" },
    ["<C-j>"] = { "<Down>", desc = "Down" },
    ["<C-k>"] = { "<Up>", desc = "Up" },
    ["<C-l>"] = { "<Right>", desc = "Right" },
  },
}

local which_key_queue = nil
--- Register queued which-key mappings
function which_key_register()
  if which_key_queue then
    local wk_avail, wk = pcall(require, "which-key")
    if wk_avail then
      for mode, registration in pairs(which_key_queue) do
        wk.register(registration, { mode = mode })
      end
      which_key_queue = nil
    end
  end
end

--- Table based API for setting keybindings
---@param map_table table A nested table where the first key is the vim mode, the second key is the key to map, and the value is the function to set the mapping to
---@param base? table A base set of options to set on every keybinding
function set_mappings(map_table, base)
  -- iterate over the first keys for each mode
  base = base or {}
  for mode, maps in pairs(map_table) do
    -- iterate over each keybinding set in the current mode
    for keymap, options in pairs(maps) do
      -- build the options for the command accordingly
      if options then
        local cmd = options
        local keymap_opts = base
        if type(options) == "table" then
          cmd = options[1]
          keymap_opts = vim.tbl_deep_extend("force", keymap_opts, options)
          keymap_opts[1] = nil
        end
        if not cmd or keymap_opts.name then -- if which-key mapping, queue it
          if not which_key_queue then which_key_queue = {} end
          if not which_key_queue[mode] then which_key_queue[mode] = {} end
          which_key_queue[mode][keymap] = keymap_opts
        else -- if not which-key mapping, set it
          vim.keymap.set(mode, keymap, cmd, keymap_opts)
        end
      end
    end
  end
  if package.loaded["which-key"] then which_key_register() end -- if which-key is loaded already, register
end

for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath('config')..'/lua/user', [[v:val =~ '\.lua$']])) do
  local uplugin = require('user.'..file:gsub('%.lua$', ''))
	if (uplugin[1] ~= nil) then
		if (uplugin.mappings ~= nil) then
			for mode, keymaps in pairs(uplugin.mappings) do
				-- Add new mode if not already existing
				if (mappings[mode] == nil) then
					mappings[mode] = {}
				end

				for key, value in pairs(keymaps) do
					mappings[mode][key] = value;
				end
			end
		end

	end
end

set_mappings(mappings);

