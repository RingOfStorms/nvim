local function prereqs()
  local output = vim.fn.system({
    "which",
    "rust-analyzer",
    "&&",
    "rust-analyzer",
    "--version",
  })
  if output == nil or output == "" or string.find(output, "not installed for the toolchain") then
    print("Installing rust-analyzer globally with rustup")
    vim.fn.system({
      "rustup",
      "component",
      "add",
      "rust-analyzer",
    })
  end
end

local servers = {
  -- rust_analyzer = USES RUST_TOOLS INSTEAD, SEE BOTTOM OF THIS FILE
  tsserver = {
    -- typescript/javascript
  },
  pyright = {
    -- python
  },
  lua_ls = {
    -- lua
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.api.nvim_get_runtime_file("", true),
          vim.fn.expand("$VIMRUNTIME/lua"),
          vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
          "/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/",
        },
      },
      telemetry = { enable = false },
      diagnostics = {
        globals = {
          "vim",
          "require",
          "hs",
        },
      },
    },
  },
  bashls = {
    -- bash
  },
  cssls = {
    -- css
  },
  cssmodules_ls = {
    -- css modules
  },
  dockerls = {
    -- docker
  },
  docker_compose_language_service = {
    -- docker compose
  },
  jsonls = {
    -- json
  },
  marksman = {
    -- markdown
  },
  taplo = {
    -- toml
  },
  yamlls = {
    -- yaml
  },
  lemminx = {
    -- xml
  },
  rnix = {
    -- Nix
  },
  ansiblels = {
    -- ansible
  },
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = true,
  signs = true,
  update_in_insert = true,
})

-- LSP config
-- Took lots of inspiration from this kickstart lua file: https://github.com/hjr3/dotfiles/blob/main/.config/nvim/init.lua

-- This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  local cursor_layout = {
    layout_strategy = "cursor",
    layout_config = { width = 0.25, height = 0.35 },
  }

  nmap("<leader>lr", vim.lsp.buf.rename, "[R]ename")
  nmap("<leader>la", vim.lsp.buf.code_action, "Code [A]ction")

  -- I dont like the default vim quickfix buffer opening for goto defintiion so use telescope
  -- nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  nmap("gd", function()
    require("telescope.builtin").lsp_definitions(cursor_layout)
  end, "[G]oto [D]efinition")
  nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  nmap("gI", function()
    require("telescope.builtin").lsp_implementations(cursor_layout)
  end, "[G]oto [I]mplementation")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<leader>sd", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

  -- disable tsserver so it does not conflict with prettier
  if client.name == "tsserver" then
    client.server_capabilities.document_formatting = false
  end
end

local gen_capabilities = function(cmp)
  -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = cmp.default_capabilities(capabilities)
end

return {
  {
    "lvimuser/lsp-inlayhints.nvim",
  },
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    opts = {
      history = true,
      region_check_events = "InsertEnter",
      delete_check_events = "TextChanged,InsertLeave",
    },
  },
  {
    -- Autocompletion
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      --"Saecki/crates.nvim", -- SEE plugins/rust-tools.lua
      "zbirenbaum/copilot-cmp",
    },
  },
  {
    "williamboman/mason.nvim",
    cmd = {
      "Mason",
      "MasonUpdate",
      "MasonInstall",
      "MasonInstallAll",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
    },
    build = ":MasonUpdate",
    opts = {},
  },
  { "folke/neodev.nvim",  opts = {} }, -- lua stuff
  {
    "williamboman/mason-lspconfig.nvim",
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      local config = require("lspconfig")
      -- local util = require("lspconfig/util")
      local mason_lspconfig = require("mason-lspconfig")
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- LSP
      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = gen_capabilities(require("cmp_nvim_lsp"))

      -- Install servers used
      mason_lspconfig.setup({
        ensure_installed = vim.tbl_keys(servers),
      })

      local flags = {
        allow_incremental_sync = true,
        debounce_text_changes = 200,
      }

      mason_lspconfig.setup_handlers({
        function(server_name)
          config[server_name].setup({
            flags = flags,
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
          })
        end,
      })

      -- Completion
      luasnip.config.setup({})

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete({}),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
              -- elseif luasnip.expand_or_jumpable() then
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = {
          {
            name = "copilot",
            priority = 8,
            keyword_length = 1,
            filter = function(keyword)
              -- Check if keyword length is some number and not just whitespace
              if #keyword < 2 or keyword:match("^%s*$") then
                return false
              end
              return true
            end,
          },
          { name = "nvim_lsp", priority = 9 },
          { nane = "buffer",   priority = 7 },
          { name = "luasnip",  priority = 6 },
          { name = "path" },
          { name = "crates" },
        },
        sorting = {
          priority_weight = 1,
          comparators = {
            cmp.config.compare.locality,
            cmp.config.compare.recently_used,
            cmp.config.compare.score,
            cmp.config.compare.offset,
            cmp.config.compare.order,
          },
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })

      -- Window borders for visibility
      local _border = "single"

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = _border,
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = _border,
      })

      vim.diagnostic.config({
        float = { border = _border },
      })

      require("lspconfig.ui.windows").default_options = {
        border = _border,
      }
    end,
  },
  { -- Rust tools
    "simrat39/rust-tools.nvim",
    build = prereqs,
    opts = {
      server = {
        on_attach = on_attach,
      },
    },
    config = function(_, opts)
      opts.server.capabilities = gen_capabilities(require("cmp_nvim_lsp"))
      require("rust-tools").setup(opts)
    end,
    --config = function(_, opts)
    --require('rust-tools').setup(opts)
    --end
  },
  { "Saecki/crates.nvim", tag = "v0.3.0", dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },
}
