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
		-- Auto save on quit
		vim.api.nvim_create_autocmd("QuitPre", {
			callback = function()
				vim.cmd("SessionSave")
			end,
		})
	end,
}
