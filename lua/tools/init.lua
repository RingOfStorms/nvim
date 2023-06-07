-- Autoload all files in this tools dir, minus this init again
for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath('config')..'/lua/tools', [[v:val =~ '\.lua$']])) do
	if file ~= "init.lua" then
		local tool = string.sub(file, 0, -5)
		require('tools.' .. tool)
	end
end

