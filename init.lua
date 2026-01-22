---@diagnostic disable: undefined-global
if NIX then
	-- Add my lua dir to the path. THIS IS NOT RECURSIVE!
	-- For recursive we can do something like this: https://github.com/RingOfStorms/nvim/blob/0b833d555c69e88b450a10eec4e39a782bad1037/init.lua#L1-L17
	-- However this pollutes the path, it could be limited to just init files but this approach here one level deep is adequate for my own needs
	package.path = package.path .. ";" .. NIX.storePath .. "/lua/?.lua"
	package.path = package.path .. ";" .. NIX.storePath .. "/lua/?/init.lua"
end

-- Compat stolen form LazyVim
vim.uv = vim.uv or vim.loop

U = require("util") -- NOTE global U[til]
require("options")
require("keymaps")

-- print("IS NIX " .. tostring(NIX ~= nil));

-- When using nix, it will set lazy via LAZY env variable.
local lazypath = vim.env.LAZY or (vim.fn.stdpath("data") .. "/lazy/lazy.nvim")
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	if NIX then
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
local function ensure_table(object)
	return type(object) == "table" and object or { object }
end
local function getSpec()
	if NIX then
		-- Convert plugins to use nix store, this auto sets the `dir` property for us on all plugins.
		local function convertPluginToNixStore(plugin)
			local p = ensure_table(plugin)
			if U.isArray(p) and #p > 1 then
				local plugins = {}
				for _, inner in ipairs(p) do
					table.insert(plugins, convertPluginToNixStore(inner))
				end
				return plugins
			end
			if p.enabled == false then
				return plugin
			end
			local nixName = "nvim_plugin-" .. p[1]
			if not NIX.pluginPaths[nixName] then
				error("Plugin is missing in the nix store, ensure it is in the nix flake inputs: " .. p[1])
				return nil
			end
			p.dir = NIX.pluginPaths[nixName]
			p.name = p.name or p[1]
			p.url = nil
			p.pin = true
			if p.dependencies then
				p.dependencies = ensure_table(p.dependencies)
				for i, dep in ipairs(p.dependencies) do
					p.dependencies[i] = convertPluginToNixStore(dep)
				end
			end
			return p
		end

		local plugins = {}
		local plugins_path = debug.getinfo(2, "S").source:sub(2):match("(.*/)") .. "lua/plugins"
		for _, file in ipairs(vim.fn.readdir(plugins_path)) do
			if file:match("%.lua$") then
				local plugin = string.sub(file, 0, -5)
				local converted = convertPluginToNixStore(require("plugins." .. plugin))
				if converted ~= nil then
					table.insert(plugins, converted)
				end
			end
		end
		return plugins
	else
		return { { import = "plugins" } }
	end
end

local s = getSpec()
-- vim.print(s)
require("lazy").setup({
	spec = s,
	change_detection = {
		enabled = false,
	},
	checker = { enabled = false },
	defaults = {
		lazy = true,
	},
	rocks = { enabled = false },
})

vim.cmd("colorscheme catppuccin")
require("tools")
require("autocommands")
