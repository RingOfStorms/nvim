return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "windwp/nvim-ts-autotag", "JoosepAlviste/nvim-ts-context-commentstring" },
  init = function()
    U.cmd_executable("tree-sitter", {
      [false] = function()
        vim.notify("tree-sitter not installed, code syntax will be broken.", 2)
      end,
    })
  end,
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
  opts = function()
    local nonNixOpts = {}
    if not NIX then
      nonNixOpts = {
        ensure_installed = "all",
        auto_install = true,
      }
    end
    return U.assign({
      highlight = {
        enable = true,
        use_languagetree = true,
        disable = function(_, bufnr)
          return vim.api.nvim_buf_line_count(bufnr) > 10000
        end,
        -- additional_vim_regex_highlighting = false,
      },
      incremental_selection = { enable = true },
      ident = { enable = true },
      autotag = { enable = true },
      rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
      },
    }, nonNixOpts)
  end,
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
