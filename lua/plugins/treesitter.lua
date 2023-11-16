local auto = true
local output = vim.fn.system({
  "which",
  "tree-sitter",
})
if output == nil or output == "" then
  auto = false
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "windwp/nvim-ts-autotag", "JoosepAlviste/nvim-ts-context-commentstring" },
    build = ":TSUpdate",
    event = "BufRead",
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
      -- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
      --ensure_installed = "all",
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
      -- auto_install = auto,
      highlight = {
        enable = true,
        use_languagetree = true,
        -- disable = function(_, bufnr) return vim.api.nvim_buf_line_count(bufnr) > 10000 end,
        -- additional_vim_regex_highlighting = false,
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
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  "nvim-treesitter/playground",
}
