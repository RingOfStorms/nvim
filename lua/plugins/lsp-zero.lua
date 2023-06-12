return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v2.x',
  dependencies = {
    -- LSP Support
    { 'neovim/nvim-lspconfig' },
    {
      'williamboman/mason.nvim',
      build = function()
        pcall(vim.cmd, 'MasonUpdate')
      end,
    },
    { 'williamboman/mason-lspconfig.nvim' },
    -- Autocompletion
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' },
    -- Snips
    { 'L3MON4D3/LuaSnip' },
  },
  config = function()
    local lsp = require('lsp-zero').preset({})
    local config = require 'lspconfig'
    local util = require 'lspconfig/util'
    local cmp = require 'cmp'
    local cmp_action = require('lsp-zero').cmp_action()

    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    capabilities = vim.tbl_deep_extend("keep", capabilities, vim.lsp.protocol.make_client_capabilities());
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    local on_attach = function(_, bufnr)
      lsp.default_keymaps({ buffer = bufnr })
    end

    lsp.on_attach(on_attach)
    lsp.ensure_installed({
      --      -- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
      "lua_ls",
      "rust_analyzer",
      "tsserver",
      "eslint",
      "cssls",
      "cssmodules_ls",
      "pyright",
      "prettierd",
      "html",
      "emmet_ls",
      "sqlls",
      "dockerls",
      "docker_compose_language_service",
    })

    config.lua_ls.setup(lsp.nvim_lua_ls())

    config.rust_analyzer.setup {}

    config.tsserver.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      root_dir = nvim_lsp.util.root_pattern("tsconfig.json", ".git"),

    }
    config.eslint.setup {}
    config.cssls.setup {}
    config.cssmodules_ls.setup {}

    config.pyright.setup {}

    lsp.setup()

    cmp.setup({
      window = {
        documentation = cmp.config.window.bordered(),
      },
      sources = {
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip",  priority = 750, keyword_length = 2 },
        { name = "buffer",   priority = 500, keyword_length = 3 },
        { name = "path",     priority = 250 },
      },
      mapping = {
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<Tab>'] = cmp_action.tab_complete(),
        ['<S-Tab>'] = cmp_action.select_prev_or_fallback(),
        -- Ctrl+Space to trigger completion menu
        ['<C-Space>'] = cmp.mapping.complete(),

        ['<C-f>'] = cmp_action.luasnip_jump_forward(),
        ['<C-b>'] = cmp_action.luasnip_jump_backward(),
      }
    })
  end,
  --  keys = {
  --    { "<leader>l", "<Nop>", desc = "LSP" },
  --  },
}
