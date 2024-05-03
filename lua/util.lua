local M = {}

function M.isArray(table)
	local i = 0
	for _ in pairs(table) do
		i = i + 1
		if table[i] == nil then
			return false
		end
	end
	return true
end

function M.cmd_executable(cmd, callback)
	local executable = vim.fn.executable(cmd) == 1
	-- Check if a callback is provided and it is a function
	if executable and callback and type(callback) == "function" then
		callback()
	end

	-- Check if a callback is provided and it is a table
	if type(callback) == "table" then
		if executable and (callback[1] or callback[true]) then
			-- Call the function associated with key 1 or true if the command is executable
			local func = callback[1] or callback[true]
			if type(func) == "function" then
				func()
			end
		elseif not executable and (callback[2] or callback[false]) then
			-- Call the function associated with key 2 or false if the command is not executable
			local func = callback[2] or callback[false]
			if type(func) == "function" then
				func()
			end
		end
	end

	return executable
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
	local opts = { silent = true }
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

-- spread({})({})
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

-- assign({}, {})
function M.assign(obj, assign)
	for key, value in pairs(assign) do
		obj[key] = value
	end
	return obj
end

function M.table_contains(table, element)
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
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

function M.safeRequire(module, func, errorFunc)
	local ok, result = pcall(require, module)
	if ok then
		return func(result)
	elseif errorFunc then
		return errorFunc(result)
	end
	return nil
end

function M.fnFalse()
	return false
end

function M.fnNil()
	return nil
end

function M.fnEmptyStr()
	return ""
end

function M.fnZero()
	return 0
end

return M
