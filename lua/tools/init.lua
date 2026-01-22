-- Require all files in this tools dir, minus this init.lua file
local function script_path()
   return debug.getinfo(2, "S").source:sub(2):match("(.*/)")
end
-- Extract the directory name from the script path
local directory_name = script_path():match(".*/(.*)/")
for _, file in ipairs(vim.fn.readdir(script_path())) do
  if file ~= "init.lua" and file:match("%.lua$") then
    local neighbor = string.sub(file, 0, -5)
    require(directory_name .. "." .. neighbor)
  end
end

