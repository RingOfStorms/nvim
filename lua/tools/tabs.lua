local function reindex_tabs()
	local tabs = vim.fn.gettabinfo()
	for i, tab in ipairs(tabs) do
		vim.cmd(string.format("silent! %dtabn", tab.tabnr))
		if i ~= tab.tabnr then
			vim.cmd(string.format("silent! tabmove %d", i - 1))
		end
	end
end

local function switch_to_tab(tab_number)
	local tabs = vim.fn.gettabinfo()
	if tab_number <= #tabs then
		vim.cmd(string.format("%dtabn", tab_number))
	end
end

local function close_current_tab()
	vim.cmd("tabclose")
	reindex_tabs()
end

-- Create autocommand to reindex tabs when a tab is closed
vim.api.nvim_create_autocmd("TabClosed", {
	callback = function()
		vim.schedule(reindex_tabs)
	end,
})

-- Show custom tab name
-- vim.o.showtabline = 2
vim.o.tabline = "%!v:lua.CustomTabLine()"
-- vim.opt.tabline = '%!t'

function _G.CustomTabLine()
	local tabline = ""
	for i = 1, vim.fn.tabpagenr("$") do
		-- Determine the active state
		local hl = i == vim.fn.tabpagenr() and "%#TabLineSel#" or "%#TabLine#"

		-- Get the tab name
		local tab_name = "Tab"

		-- Check if a custom name exists
		if vim.g.tab_names and vim.g.tab_names[i] then
			tab_name = vim.g.tab_names[i]
		else
			-- If no custom name, try to get buffer name
			local winnr = vim.fn.tabpagewinnr(i)
			local buflist = vim.fn.tabpagebuflist(i)
			local bufnr = buflist[winnr]
			local filename = vim.fn.bufname(bufnr)

			-- Use filename or default
			if filename ~= "" then
				tab_name = vim.fn.fnamemodify(filename, ":t")
			end
		end

		-- Create tab label
		tabline = tabline .. hl .. "%" .. i .. "T " .. i .. ":" .. tab_name .. " %T"
	end

	-- Fill the rest of the tabline
	tabline = tabline .. "%#TabLineFill#%T"
	return tabline
end

local nvx = { "n", "v", "x" }
U.keymaps({
	-- Tabs
	{ "<leader>tc", "<cmd>tabnew<cr>", desc = "Create new tab", mode = nvx },
	{ "<leader>tx", close_current_tab, desc = "Close current tab", mode = nvx },

	-- Switch to tabs 1-9
	{
		"<leader>t1",
		function()
			switch_to_tab(1)
		end,
		desc = "Switch to tab 1",
		mode = nvx,
	},
	{
		"<leader>t2",
		function()
			switch_to_tab(2)
		end,
		desc = "Switch to tab 2",
		mode = nvx,
	},
	{
		"<leader>t3",
		function()
			switch_to_tab(3)
		end,
		desc = "Switch to tab 3",
		mode = nvx,
	},
	{
		"<leader>t4",
		function()
			switch_to_tab(4)
		end,
		desc = "Switch to tab 4",
		mode = nvx,
	},
	{
		"<leader>t5",
		function()
			switch_to_tab(5)
		end,
		desc = "Switch to tab 5",
		mode = nvx,
	},
	{
		"<leader>t6",
		function()
			switch_to_tab(6)
		end,
		desc = "Switch to tab 6",
		mode = nvx,
	},
	{
		"<leader>t7",
		function()
			switch_to_tab(7)
		end,
		desc = "Switch to tab 7",
		mode = nvx,
	},
	{
		"<leader>t8",
		function()
			switch_to_tab(8)
		end,
		desc = "Switch to tab 8",
		mode = nvx,
	},
	{
		"<leader>t9",
		function()
			switch_to_tab(9)
		end,
		desc = "Switch to tab 9",
		mode = nvx,
	},
})
