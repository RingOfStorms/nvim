local M = {}

function M.keymaps_old(mappings)
  for mode, maps in pairs(mappings) do
    for keymap, options in pairs(maps) do
      if options then
        local cmd = options
        local keymap_opts = {}
        if type(options) == "table" then
          cmd = options[1]
          keymap_opts = vim.tbl_deep_extend("force", keymap_opts, options)
          keymap_opts[1] = nil
        end

        if mode and keymap and cmd and keymap_opts then
          vim.keymap.set(mode, keymap, cmd, keymap_opts)
        end
      end
    end
  end
end

--     [1]: (string) lhs (required)
--     [2]: (string|fun()) rhs (optional)
--     mode: (string|string[]) mode (optional, defaults to "n")
--     ft: (string|string[]) filetype for buffer-local keymaps (optional)
--     any other option valid for vim.keymap.set
function M.keymaps(keymaps)
  -- is not an array, will pass directly to keymaps
  if type(keymaps[1]) == "string" then
    M.keymap(keymaps)
  else
    -- is array will iterate over
    for _, keymap in pairs(keymaps) do
      M.keymap(keymap)
    end
  end
end

function M.keymap(keymap)
  local lhs = keymap[1]
  local rhs = keymap[2]
  local mode = keymap["mode"] or "n"
  local opts = {}
  for key, value in pairs(keymap) do
    if type(key) ~= "number" and key ~= "mode" then
      opts[key] = value
    end
  end

  local status, err = pcall(function()
    vim.keymap.set(mode, lhs, rhs, opts)
  end)
  if not status then
    vim.notify("Failed to create keymap: " .. err, 3)
  end
end

function M.spread(template)
  local result = {}
  for key, value in pairs(template) do
    result[key] = value
  end

  return function(table)
    for key, value in pairs(table) do
      result[key] = value
    end
    return result
  end
end

-- From https://github.com/lukas-reineke/onedark.nvim/blob/master/lua/onedark.lua
function M.highlight(group, options)
  local guifg = options.fg or "NONE"
  local guibg = options.bg or "NONE"
  local guisp = options.sp or "NONE"
  local gui = options.gui or "NONE"
  local blend = options.blend or 0
  local ctermfg = options.ctermfg or "NONE"

  vim.cmd(
    string.format(
      "highlight %s guifg=%s ctermfg=%s guibg=%s guisp=%s gui=%s blend=%d",
      group,
      guifg,
      ctermfg,
      guibg,
      guisp,
      gui,
      blend
    )
  )
end

return M
