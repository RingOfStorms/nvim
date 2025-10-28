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
		require("remote-sshfs").setup(opts)
		require("telescope").load_extension("remote-sshfs")
	end,
}
