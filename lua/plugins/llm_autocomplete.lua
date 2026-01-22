-- Local AI autocomplete using llama.vim
-- Supports sweep-next-edit-1.5B and other FIM-capable models via llama-server
--
-- Usage:
--   1. Start llama-server with your model:
--      llama-server -m sweep-next-edit-Q8_0.gguf --port 8012 --fim-qwen-7b-default
--   2. Neovim will auto-detect the server and enable completions
--   3. Use Tab to accept, Shift-Tab for first line, Ctrl-F to toggle
--   4. Toggle on/off with <leader>,a

-- Check if llama-server is running (sync, for cond check)
local function is_llama_server_running()
	-- Quick sync check - only used at startup
	local result = vim.system(
		{ "curl", "-s", "-o", "/dev/null", "-w", "%{http_code}", "--connect-timeout", "0.5", "http://127.0.0.1:8012/health" },
		{ text = true }
	):wait()
	return result.code == 0 and result.stdout and result.stdout:match("200")
end

-- Cache the server status at load time
local server_available = nil

return {
	"ggml-org/llama.vim",
	-- Only load if llama-server is running, or load lazily via command
	cond = function()
		if server_available == nil then
			server_available = is_llama_server_running()
		end
		return server_available
	end,
	event = "InsertEnter",
	init = function()
		-- Default configuration
		vim.g.llama_config = {
			endpoint = "http://127.0.0.1:8012/infill",
			auto_fim = true, -- Enable since we only load when server is available
			show_info = 1,
			-- Keymaps are handled by the plugin:
			-- Tab - accept completion
			-- Shift-Tab - accept first line only
			-- Ctrl-F - toggle FIM manually
		}
		vim.notify("llama.vim: server detected, AI completions enabled", vim.log.levels.INFO)
	end,
	keys = {
		{
			"<leader>,a",
			function()
				-- Toggle auto_fim
				if vim.g.llama_config then
					vim.g.llama_config.auto_fim = not vim.g.llama_config.auto_fim
					local status = vim.g.llama_config.auto_fim and "enabled" or "disabled"
					vim.notify("llama.vim auto-complete " .. status, vim.log.levels.INFO)
				end
			end,
			desc = "Toggle AI autocomplete (llama.vim)",
		},
	},
}
