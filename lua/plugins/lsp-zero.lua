return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v2.x',
  dependencies = {
    -- LSP Support
    {'neovim/nvim-lspconfig'},
    {
      'williamboman/mason.nvim',
      build = function()
        pcall(vim.cmd, 'MasonUpdate')
      end,
    },
    {'williamboman/mason-lspconfig.nvim'},
    -- Autocompletion
    {'hrsh7th/nvim-cmp'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/cmp-buffer'},
    {'hrsh7th/cmp-path'},
    {'hrsh7th/cmp-cmdline'},
    -- Snips
    {'L3MON4D3/LuaSnip'},
  },
  config = function()
    local lsp = require('lsp-zero').preset({})
    local config = require 'lspconfig'
    local util = require 'lspconfig/util'

    lsp.on_attach(function(_, bufnr)
      lsp.default_keymaps({ buffer = bufnr })
    end)

    lsp.ensure_installed({
      --      -- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
      "lua_ls",
      "rust_analyzer",
      "tsserver",
      "eslint",
      "cssls",
      "cssmodules_ls",
      "pyright",
    })

    config.lua_ls.setup(lsp.nvim_lua_ls())

    config.rust_analyzer.setup {}

    config.tsserver.setup {}
    config.eslint.setup {}
    config.cssls.setup {}
    config.cssmodules_ls.setup {}

    config.pyright.setup {}

    local cmp = require 'cmp'
    local cmp_action = require('lsp-zero').cmp_action()

    cmp.setup({
      sources = {
        { name = "path" },
        { name = "nvim_lsp" },
        { name = "buffer", keyword_length = 3 },
        { name = "luasnip", keyword_length= 2 },
      },
      mapping = {
        ['<CR>'] = cmp.mapping.confirm({select = false}),
        ['<Tab>'] = cmp_action.tab_complete(),
        ['<S-Tab>'] = cmp_action.select_prev_or_fallback(),
        -- Ctrl+Space to trigger completion menu
        ['<C-Space>'] = cmp.mapping.complete(),

        ['<C-f>'] = cmp_action.luasnip_jump_forward(),
        ['<C-b>'] = cmp_action.luasnip_jump_backward(),
      }
    })
    lsp.setup()
  end,
  --  keys = {
  --    { "<leader>l", "<Nop>", desc = "LSP" },
  --  },
}
