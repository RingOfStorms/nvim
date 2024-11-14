return {
	"nosduco/remote-sshfs.nvim",
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
