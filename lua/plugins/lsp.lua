return {
  "neovim/nvim-lspconfig",
  event = "BufEnter",
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { "williamboman/mason.nvim", enabled = not NIX, config = true }, -- NOTE: Must be loaded before dependants
    { "williamboman/mason-lspconfig.nvim", enabled = not NIX },
    { "WhoIsSethDaniel/mason-tool-installer.nvim", enabled = not NIX },

    -- Useful status updates for LSP.
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    -- { "j-hui/fidget.nvim", opts = {} },

    -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    -- { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("myconfig-lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end
        map("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
        map("gr", require("telescope.builtin").lsp_references, "Goto References")
        map("gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")
        -- TODO do I want these?
        -- map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type Definition")
        -- map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
        -- map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")
        map("<leader>lr", vim.lsp.buf.rename, "Rename")
        map("<leader>la", vim.lsp.buf.code_action, "Code Action")
        map("K", vim.lsp.buf.hover, "Hover Documentation")
        map("gD", vim.lsp.buf.declaration, "Goto Declaration")

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        -- The following autocommand is used to enable inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          map("<leader>lth", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, "Toggle Inlay Hints")
        end
      end,
    })

    vim.api.nvim_create_autocmd("LspDetach", {
      group = vim.api.nvim_create_augroup("myconfig-lsp-detach", { clear = true }),
      callback = function(event)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds({ group = "myconfig-lsp-highlight", buffer = event.buf })
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- TODO
    -- capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    local servers = {
      -- clangd = {},
      -- gopls = {},
      -- pyright = {},
      -- rust_analyzer = {},
      -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
      --
      -- Some languages (like typescript) have entire language plugins that can be useful:
      --    https://github.com/pmizio/typescript-tools.nvim
      --
      -- But for many setups, the LSP (`tsserver`) will work just fine
      tsserver = {},

      lua_ls = {
        -- cmd = { ... },
        -- filetypes = { ...},
        -- capabilities = {},
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = "LuaJIT",
            },
            completion = {
              callSnippet = "Replace",
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                vim.api.nvim_get_runtime_file("", true),
                vim.fn.expand("$VIMRUNTIME/lua"),
                vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
              },
              telemetry = { enable = false },
              diagnostics = {
                globals = {
                  "vim",
                  "require",
                  "NIX",
                  "U",
                  -- Hammerspoon
                  "hs",
                },
              },
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
    }
    if NIX then
      local servers = vim.tbl_keys(servers or {})
      for _, server_name in ipairs(servers) do
        local server_opts = servers[server_name] or {}
        require("lspconfig")[server_name].setup(server_opts)
      end
    else
      require("mason").setup()
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua", -- Used to format Lua code TODO come back to this, more about linter/formatter configs
      })
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end
  end,
}
