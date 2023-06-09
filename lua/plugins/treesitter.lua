return {
  "nvim-treesitter/nvim-treesitter",
	dependencies = { "windwp/nvim-ts-autotag", "JoosepAlviste/nvim-ts-context-commentstring" },
	commit = "f2778bd1a28b74adf5b1aa51aa57da85adfa3d16",
  build = ":TSUpdate",
	event = "BufEnter",
	cmd = {
    "TSBufDisable",
    "TSBufEnable",
    "TSBufToggle",
    "TSDisable",
    "TSEnable",
    "TSToggle",
    "TSInstall",
    "TSInstallInfo",
    "TSInstallSync",
    "TSModuleInfo",
    "TSUninstall",
    "TSUpdate",
    "TSUpdateSync",
  },
  opts = {
    -- "all",
    ensure_installed = {
      "lua",
      "http",
      "json",
      "bash",
      "css",
      "diff",
      "dockerfile",
      "dot",
      "git_rebase",
      "gitattributes",
      "html",
      "java",
      "javascript",
      "jq",
      "jsdoc",
      "json5",
      "kotlin",
      "latex",
      "make",
      "markdown",
      "markdown_inline",
      "nix",
      "python",
      "regex",
      "rst",
      "rust",
      "scss",
      "sql",
      "terraform",
      "toml",
      "tsx",
      "typescript",
      "vue",
      "yaml",
    },
    auto_install = true,
    highlight = {
      enable = true,
			disable = function(_, bufnr) return vim.api.nvim_buf_line_count(bufnr) > 10000 end,
      additional_vim_regex_highlighting = false,
    },
		incremental_selection = { enable = true },
    ident = { enable = true },
		autotag = { enable = true },
		context_commentstring = { enable = true, enable_autocmd = false },
    rainbow = {
      enable = true,
      extended_mode = true,
      max_file_lines = nil,
    },
  },
}
