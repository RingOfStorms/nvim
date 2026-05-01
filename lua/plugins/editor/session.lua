return {
	"rmagatti/auto-session",
	lazy = false,
	init = function()
		vim.o.sessionoptions = "blank,buffers,curdir,folds,tabpages,winsize,winpos,terminal,localoptions,help"
	end,
	opts = {
		auto_session_use_git_branch = true,
		auto_session_suppress_dirs = { "~/", "sessions", "~/Downloads", "/" },
		post_cwd_changed_hook = function()
			U.safeRequire("lualine", function(ll)
				ll.refresh() -- refresh lualine so the new session name is displayed in the status bar
			end)
		end,
	},
	config = function(_, opts)
		require("auto-session").setup(opts)

		local diffview_filetypes = {
			DiffviewFiles = true,
			DiffviewFileHistory = true,
			DiffviewFHOptionPanel = true,
		}

		local function cleanup_for_session()
			-- Close every tab except the first (reverse order keeps indices valid)
			local tabs = vim.api.nvim_list_tabpages()
			for i = #tabs, 2, -1 do
				local tabnr = vim.api.nvim_tabpage_get_number(tabs[i])
				pcall(vim.cmd, "tabclose " .. tabnr)
			end

			-- Wipe leftover diffview buffers so they don't get persisted
			for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_valid(bufnr) then
					local ft = vim.bo[bufnr].filetype
					local name = vim.api.nvim_buf_get_name(bufnr)
					if diffview_filetypes[ft] or name:match("^diffview://") then
						pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
					end
				end
			end
		end

		-- Auto save on quit (after closing extra tabs so they don't persist)
		local group = vim.api.nvim_create_augroup("myconfig-auto-session-quit", { clear = true })
		vim.api.nvim_create_autocmd("QuitPre", {
			group = group,
			callback = function()
				pcall(cleanup_for_session)
				vim.cmd("AutoSession save")
			end,
		})
	end,
}
