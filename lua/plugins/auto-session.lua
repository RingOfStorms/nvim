vim.o.sessionoptions = "blank,buffers,curdir,folds,tabpages,winsize,winpos,terminal,localoptions"

return {
  "rmagatti/auto-session",
  opts = {
    auto_session_use_git_branch = true,
    auto_session_suppress_dirs = { "~/", "sessions", "~/Downloads", "/" },
  },
}
