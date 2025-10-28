return {
	"nosduco/remote-sshfs.nvim",
	init = function()
		-- Check if sshfs is available
		if not U.cmd_executable("sshfs") then
			vim.notify(
				"'sshfs' not found on PATH. Required for RemoteSSHFS commands",
				vim.log.levels.INFO
			)
		end
	end,
	cmd = {
		"RemoteSshfs",
		"RemoteSSHFSConnect",
		"RemoteSSHFSDisconnect",
		"RemoteSSHFSEdit",
		"RemoteSSHFSFindFiles",
		"RemoteSSHFSLiveGrep",
	},
	dependencies = { "nvim-telescope/telescope.nvim" },
	opts = {},
	config = function(_, opts)
		-- Check for sshfs when plugin is first used
		if not U.cmd_executable("sshfs") then
			vim.notify(
				"'sshfs' not found on PATH. Install it to use RemoteSSHFS commands.",
				vim.log.levels.ERROR
			)
		end
		require("remote-sshfs").setup(opts)
		require("telescope").load_extension("remote-sshfs")
	end,
}
