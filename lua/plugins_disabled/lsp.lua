return {
  {
    -- Mason: install and manage LSP servers, DAP servers, linters, and formatters
    "williamboman/mason.nvim",
    build = ":MasonUpdate", -- :MasonUpdate updates registry contents
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      -- Available servers: https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
      ensure_installed = {
        'lua_ls',
        'rust_analyzer',
        'tsserver',
        "eslint",
        'cssls',
        'cssmodules_ls',
        'pyright',
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function(_, opts)
      local c = require 'lspconfig'
      local u = require "lspconfig/util"

      c.lua_ls.setup {
        workspace = {
          library = {
            [vim.fn.expand "$VIMRUNTIME/lua"] = true,
            [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
            [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
          },
        },
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" }
            }
          }
        }
      }

      c.rust_analyzer.setup {
        on_attach = function() end,
        capabilities = {},
        filetypes = { "rust" },
        root_dir = u.root_pattern("Cargo.toml"),
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
            },
          },
        },
      }

      c.tsserver.setup {

      }

      c.eslint.setup {

      }

      c.cssls.setup {}

      c.cssmodules_ls.setup {}

      c.pyright.setup {}
    end
  },
}

