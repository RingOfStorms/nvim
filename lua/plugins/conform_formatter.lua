local function formatCurrent(retry)
	require("conform").format({ async = true, lsp_fallback = true }, function(err, edited)
		if edited then
			print("Formatted!")
		elseif err then
			-- Sometimes I am too fast and vim is saving from my InsertExit and this fails so
			-- I give it one retry
			if not retry and string.find(err, "concurrent modification") then
				return formatCurrent(true)
			end
			print(err)
		else
			print("Nothing to format!")
		end
	end)
end

---@param bufnr integer
---@param ... string
---@return string
local function first(bufnr, ...)
	local conform = require("conform")
	for i = 1, select("#", ...) do
		local formatter = select(i, ...)
		if conform.get_formatter_info(formatter, bufnr).available then
			return formatter
		end
	end
	return select(1, ...)
end

-- Make function that converts { { "prettierd", "prettier" }, "rustywind" } to
--function (bufnr)
-- return { first(bufnr, "prettierd", "prettier"), "rustywind" }
-- end,
local function expandFormatters(formatters)
	return function(bufnr)
		local result = {}
		for i = 1, #formatters do
			local formatter = formatters[i]
			if type(formatter) == "table" then
				result[i] = first(bufnr, unpack(formatter))
			else
				result[i] = formatter
			end
		end
		return result
	end
end

return {
	"stevearc/conform.nvim",
	init = function()
		-- Check for common formatters and warn if missing
		local formatters_to_check = {
			{ cmd = "stylua", desc = "Lua formatting" },
			{ cmd = "nixfmt", desc = "Nix formatting" },
			{ cmd = "prettier", desc = "JS/TS/Svelte formatting (alternative: prettierd)" },
			{ cmd = "rustywind", desc = "Tailwind class sorting" },
			{ cmd = "markdownlint-cli2", desc = "Markdown formatting" },
			{ cmd = "sql-formatter", desc = "SQL formatting" },
			{ cmd = "rustfmt", desc = "Rust formatting" },
		}
		
		for _, formatter in ipairs(formatters_to_check) do
			if not U.cmd_executable(formatter.cmd) then
				-- Only warn once on startup, not on every format attempt
				vim.schedule(function()
					vim.notify(
						string.format("Formatter '%s' not found. Used for: %s", formatter.cmd, formatter.desc),
						vim.log.levels.WARN
					)
				end)
			end
		end
	end,
	opts = {
		-- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#setup
		notify_on_error = true,
		formatters = {
			-- v_fmt = {
			--         command = "v",
			--         args = { "fmt" },
			-- },
		},
		-- Note that all these need to be available at runtime, add them to flake.nix#runtimeDependencies
		formatters_by_ft = {
			sql = { "sql_formatter", lsp_format = "first" },
			lua = { "stylua", lsp_format = "first" },
			nix = { "nixfmt", lsp_format = "first" },
			qml = { "qmlformat", lsp_format = "first" },
			typescript = expandFormatters({ { "prettierd", "prettier" }, "rustywind", lsp_format = "first" }),
			typescriptreact = expandFormatters({ { "prettierd", "prettier" }, "rustywind", lsp_format = "first" }),
			javascript = expandFormatters({ { "prettierd", "prettier" }, "rustywind", lsp_format = "first" }),
			javascriptreact = expandFormatters({ { "prettierd", "prettier" }, "rustywind", lsp_format = "first" }),
			svelte = expandFormatters({ { "prettierd", "prettier" }, "rustywind", lsp_format = "first" }),

			-- TODO revisit these I'd like to use them but they are not in nixpkgs yet
			-- https://nixos.org/guides/nix-pills/
			-- markdown = { "mdslw", "mdsf"},
			markdown = { "markdownlint-cli2", lsp_format = "first" },
			rust = { "rustfmt", lsp_format = "first" },
		},
	},
	keys = {
		{
			"<leader>l<leader>",
			formatCurrent,
			mode = { "n", "v", "x" },
			desc = "Format buffer",
		},
	},
}
