print("LOADING... is nix: " .. vim.inspect(IS_NIX))

if IS_NIX then
  -- Add my lua dir to the path. THIS IS NOT RECURSIVE!
  -- For recursive we can do something like this: https://github.com/RingOfStorms/nvim/blob/0b833d555c69e88b450a10eec4e39a782bad1037/init.lua#L1-L17
  -- However this pollutes the path, it oculd be limited to just init files but this approach here one level deep is adequate for my own needs
  package.path = package.path .. ";" .. NVIM_CONFIG_STORE_PATH .. "/lua/?.lua"
  package.path = package.path .. ";" .. NVIM_CONFIG_STORE_PATH .. "/lua/?/init.lua"
end

require("options")
require("keymaps")

-- When using nix, it will set lazy via LAZY env variable.
local lazypath = vim.env.LAZY or (vim.fn.stdpath("data") .. "/lazy/lazy.nvim")
if not vim.loop.fs_stat(lazypath) then
  if IS_NIX then
    error("LAZY environment variable to nix store was not found: " .. vim.env.LAZY)
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

-- Setup lazy
function getSpec()
  if IS_NIX then
    local plugins = {}
    local plugins_path = debug.getinfo(2, "S").source:sub(2):match("(.*/)") .. "lua/plugins"
    for _, file in ipairs(vim.fn.readdir(plugins_path, [[v:val =~ '\.lua$']])) do
      local plugin = string.sub(file, 0, -5)
      table.insert(plugins, require("plugins." .. plugin))
    end
    return plugins
  else
    -- TODO I want this to work in the nixos version
    -- but it is not resolving properly to the nix store.
    -- Will revisit at some point, instead we manually pull them
    -- in above with a directory scan.
    return { { import = "plugins" } }
  end
end
require("lazy").setup({
  spec = getSpec(),
  change_detection = {
    enabled = false,
  },
  defaults = {
    -- lazy = true
  },
})

vim.cmd("colorscheme catppuccin")
require("tools")
require("autocommands")
