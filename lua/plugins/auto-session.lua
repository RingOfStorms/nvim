vim.o.sessionoptions = "blank,curdir,folds,tabpages,winsize,winpos" -- `buffers` excluded will only save buffers in windows (add in for hidden/etc)

return {
  "rmagatti/auto-session",
  opts = {
    auto_session_use_git_branch = true,
    auto_session_suppress_dirs = { "~/", "sessions", "~/Downloads", "/" },
  },
}
