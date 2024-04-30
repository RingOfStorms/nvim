if NVIM_CONFIG_STORE_PATH then
  -- Function to add subdirectories to package.path
  local function add_lua_subdirs_to_path(base_dir)
    local scan_dir
    scan_dir = function(dir)
      package.path = package.path .. ";" .. dir .. "?.lua"
      package.path = package.path .. ";" .. dir .. "?/init.lua"
      local paths = vim.fn.globpath(dir, '*/', 0, 1)
      for _, subdir in ipairs(paths) do
        scan_dir(subdir) -- Recursively add subdirectories
      end
    end
    scan_dir(base_dir)
  end
  -- Call the function with the base directory of your Lua modules
  add_lua_subdirs_to_path(NVIM_CONFIG_STORE_PATH .. "/lua/")
end

require("options")
require("keymaps")

print("NIX FLAKE NVIM: nvim packages " .. vim.inspect(NVIM_PLUGIN_PATHS))

-- When using nix, it will set lazy via LAZY env variable.
local lazypath = vim.env.LAZY or (vim.fn.stdpath("data") .. "/lazy/lazy.nvim")
if not vim.loop.fs_stat(lazypath) then
  if vim.env.LAZY then
    error("LAZY environment variable provided but it does not exist at path: " .. vim.env.LAZY)
    return
  end
  -- For non nix systems, pull lazy stable to the normal XDG config path
  local output = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
  if vim.api.nvim_get_vvar("shell_error") ~= 0 then
    error("Error cloning lazy.nvim repository...\n\n" .. output)
  end
end
vim.opt.rtp:prepend(lazypath)

print("TEST")
local asd = require("catppuccin")
print("TEST2 " .. vim.inspect(asd))

-- Setup lazy
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  change_detection = {
    enabled = false,
  },
  defaults = {
    -- lazy = true
  },
  -- install = {
  --   colorscheme = { "catppuccin" },
  -- }
})

-- vim.cmd("colorscheme catppuccin")
require("tools")
require("autocommands")
