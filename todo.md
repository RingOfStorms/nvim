# Neovim Configuration Modernization TODO

## Overview

This document tracks the modernization of the neovim configuration with focus on:
- Reducing nix flake bloat via direnv + project devShells
- Replacing nvim-cmp with faster blink.cmp
- Adding local AI autocomplete via llama.vim (for sweep-next-edit-1.5B)
- Consolidating plugins with mini.nvim
- Improving diagnostics UX with trouble.nvim
- Better Lua development with lazydev.nvim
- Restructuring LSP/lint/format modules

---

## Phase 1: Nix Dependency Reduction

### 1.1 Modify flake.nix
- [ ] Move most LSPs from `runtimeDependenciesFull` to project devShells
- [ ] Keep in core: `rg`, `fd`, `tree-sitter`, `fzf`, `glow`, `curl`, `sshfs`, `nixfmt`, `nil`, `stylua`, `lua-language-server`
- [ ] Add `direnv` to `runtimeDependenciesCore`
- [ ] Create a new tier: `runtimeDependenciesCommon` for commonly used formatters (prettier, stylua) that aren't LSPs

### 1.2 Add new flake inputs for new plugins
- [ ] `nvim_plugin-saghen/blink.cmp`
- [ ] `nvim_plugin-folke/trouble.nvim`
- [ ] `nvim_plugin-echasnovski/mini.nvim`
- [ ] `nvim_plugin-folke/lazydev.nvim`
- [ ] `nvim_plugin-direnv/direnv.vim`
- [ ] `nvim_plugin-ggml-org/llama.vim`

### 1.3 Remove deprecated/unused flake inputs
- [ ] `nvim_plugin-folke/neodev.nvim` (replaced by lazydev)
- [ ] `nvim_plugin-zbirenbaum/copilot.lua` (removing copilot)
- [ ] `nvim_plugin-zbirenbaum/copilot-cmp` (removing copilot)
- [ ] `nvim_plugin-CopilotC-Nvim/CopilotChat.nvim` (removing copilot)
- [ ] `nvim_plugin-hrsh7th/nvim-cmp` (replaced by blink.cmp)
- [ ] `nvim_plugin-saadparwaiz1/cmp_luasnip` (nvim-cmp dependency)
- [ ] `nvim_plugin-hrsh7th/cmp-nvim-lsp` (nvim-cmp dependency)
- [ ] `nvim_plugin-hrsh7th/cmp-path` (nvim-cmp dependency)
- [ ] `nvim_plugin-hrsh7th/cmp-buffer` (nvim-cmp dependency)
- [ ] `nvim_plugin-numToStr/Comment.nvim` (replaced by mini.comment)
- [ ] `nvim_plugin-JoosepAlviste/nvim-ts-context-commentstring` (Comment.nvim dep, mini.comment uses native treesitter)
- [ ] `nvim_plugin-tpope/vim-surround` (replaced by mini.surround)

---

## Phase 2: Replace nvim-cmp with blink.cmp

### 2.1 Create new completion config
- [ ] Create `lua/plugins/completion.lua` with blink.cmp setup
- [ ] Configure keymaps: `<C-j>`/`<C-k>` select, `<C-y>` accept, `<C-u>`/`<C-d>` scroll docs
- [ ] Enable ghost text preview
- [ ] Enable signature help
- [ ] Configure sources: lsp, path, snippets, buffer

### 2.2 Remove old completion config
- [ ] Delete `lua/plugins/cmp_autocompletion.lua`
- [ ] Keep `L3MON4D3/LuaSnip` and `rafamadriz/friendly-snippets` for snippet support

### 2.3 Update LSP config
- [ ] Remove `cmp_nvim_lsp.default_capabilities()` call (blink.cmp handles this differently)
- [ ] Update capabilities setup for blink.cmp compatibility

---

## Phase 3: Local AI Autocomplete (llama.vim)

### 3.1 Create llama.vim config
- [ ] Create `lua/plugins/llm_autocomplete.lua`
- [ ] Auto-detect if llama-server is running on startup (check endpoint)
- [ ] Configure for FIM (fill-in-middle) completion
- [ ] Default endpoint: `http://127.0.0.1:8012/infill`
- [ ] Add toggle keymap `<leader>,a` to enable/disable

### 3.2 Document llama-server setup
- [ ] Add README section for running llama-server with sweep-next-edit-1.5B
- [ ] Example command: `llama-server -m sweep-next-edit-Q8_0.gguf --port 8012 --fim-qwen-7b-default`

### 3.3 Remove copilot
- [ ] Delete copilot references from `lua/plugins/cmp_autocompletion.lua` (will be deleted anyway)
- [ ] Ensure no other files reference copilot

---

## Phase 4: Add direnv.vim

### 4.1 Create direnv config
- [ ] Create `lua/plugins/direnv.lua`
- [ ] Load early (priority 90) to set up env before LSP starts
- [ ] Consider: auto-allow for trusted directories?

---

## Phase 5: Smart LSP Detection & Warnings

### 5.1 Create detection utility
- [ ] Add to `lua/util.lua` or create `lua/lsp_detect.lua`:
  - Function to check if expected LSP is available for filetype
  - Mapping of filetypes to expected LSP binaries
  - Notification helper for missing LSPs

### 5.2 Integrate into LSP config
- [ ] Add `FileType` autocmd that checks for expected LSP
- [ ] Show notification if LSP missing: "LSP '{name}' for {ft} not found. Add to project devShell."
- [ ] Debounce notifications (don't spam on startup)
- [ ] Option to disable warnings per-filetype or globally

### Expected LSP mapping:
```lua
local expected_lsp = {
  rust = "rust-analyzer",
  typescript = "typescript-language-server",
  typescriptreact = "typescript-language-server",
  javascript = "typescript-language-server",
  javascriptreact = "typescript-language-server",
  python = "pylsp",
  go = "gopls",
  svelte = "svelteserver",
  css = "vscode-css-language-server",
  html = "vscode-html-language-server",
  json = "vscode-json-language-server",
  yaml = "yaml-language-server",
  toml = "taplo",
  markdown = "marksman",
  xml = "lemminx",
  -- lua and nix handled by core dependencies
}
```

---

## Phase 6: Add trouble.nvim for Diagnostics

### 6.1 Create trouble.nvim config
- [ ] Create `lua/plugins/diagnostics.lua`
- [ ] Configure modes: diagnostics, symbols, quickfix
- [ ] Keymaps under `<leader>x`:
  - `<leader>xx` - Toggle diagnostics
  - `<leader>xX` - Buffer diagnostics only
  - `<leader>xs` - Document symbols sidebar
  - `<leader>xq` - Quickfix list

### 6.2 Update which-key
- [ ] Add `x` group: "Trouble/Diagnostics"

### 6.3 Optional: Telescope integration
- [ ] Add `<C-t>` in telescope to send results to trouble

---

## Phase 7: Add lazydev.nvim

### 7.1 Create lazydev config
- [ ] Create `lua/plugins/lazydev.lua`
- [ ] Configure for lua filetype
- [ ] Add luv library annotation

### 7.2 Update LSP config
- [ ] Remove manual `lua_ls` workspace library configuration
- [ ] Remove neodev.nvim dependency from lsp.lua
- [ ] Let lazydev handle Neovim API completions

---

## Phase 8: mini.nvim Consolidation

### 8.1 Create mini.nvim config
- [ ] Create `lua/plugins/mini.lua`
- [ ] Configure modules:
  - `mini.surround` - replaces vim-surround (mappings: `gsa`/`gsd`/`gsr`)
  - `mini.comment` - replaces Comment.nvim (mappings: `gc`/`gcc`)
  - `mini.pairs` - auto pairs (optional, consider if wanted)
  - `mini.ai` - enhanced text objects

### 8.2 Handle comment keybindings
- [ ] Current: `<leader>/` for toggle comment
- [ ] Preserve this mapping in mini.comment config or via custom keymap

### 8.3 Remove replaced plugins
- [ ] Delete `lua/plugins/surround.lua`
- [ ] Delete `lua/plugins/comments_support.lua`

---

## Phase 9: File Restructuring

### 9.1 Rename files for consistency
- [ ] `conform_formatter.lua` -> `formatting.lua`
- [ ] `lint.lua` -> `linting.lua`

### 9.2 Consider LSP module restructure (optional)
Current `lsp.lua` is large. Could split into:
```
lua/plugins/lsp/
├── init.lua         # Main setup, keymaps
├── servers.lua      # Server-specific configs
└── detect.lua       # Smart detection logic
```
Decision: Keep as single file unless it becomes unwieldy after changes.

---

## Phase 10: Cleanup & Testing

### 10.1 Test nix mode
- [ ] Run `nix run .` and verify all plugins load
- [ ] Check LSP works for lua and nix (core deps)
- [ ] Verify warning appears for other filetypes without LSP

### 10.2 Test non-nix mode
- [ ] Clone fresh, run `nvim --headless "+Lazy! sync" +qa`
- [ ] Verify lazy.nvim fetches all plugins

### 10.3 Verify lazy loading
- [ ] Check startup time with `:Lazy profile`
- [ ] Ensure plugins are still lazy loaded appropriately

### 10.4 Update README
- [ ] Update "Without Nix" section
- [ ] Add section on direnv/devShell integration
- [ ] Add section on llama.vim / local AI setup
- [ ] Remove copilot mentions
- [ ] Update requirements (Neovim version, etc.)

---

## Files Summary

### Create
| File | Description |
|------|-------------|
| `lua/plugins/completion.lua` | blink.cmp configuration |
| `lua/plugins/llm_autocomplete.lua` | llama.vim for local AI |
| `lua/plugins/direnv.lua` | direnv.vim configuration |
| `lua/plugins/diagnostics.lua` | trouble.nvim configuration |
| `lua/plugins/lazydev.lua` | lazydev.nvim configuration |
| `lua/plugins/mini.lua` | mini.nvim modules |

### Modify
| File | Changes |
|------|---------|
| `flake.nix` | Add/remove inputs, adjust dependencies |
| `lua/plugins/lsp.lua` | Add detection, remove neodev, update capabilities |
| `lua/plugins/whichkey.lua` | Add trouble group |
| `README.md` | Update documentation |

### Delete
| File | Reason |
|------|--------|
| `lua/plugins/cmp_autocompletion.lua` | Replaced by blink.cmp |
| `lua/plugins/surround.lua` | Replaced by mini.surround |
| `lua/plugins/comments_support.lua` | Replaced by mini.comment |

### Rename
| From | To |
|------|-----|
| `lua/plugins/conform_formatter.lua` | `lua/plugins/formatting.lua` |
| `lua/plugins/lint.lua` | `lua/plugins/linting.lua` |

---

## Sub-Agent Task Prompts

These tasks can be executed in parallel by sub-agents. Each prompt is self-contained.

### Parallel Group A: New Plugin Configs (No Dependencies)

#### Task A1: Create blink.cmp config
```
Create lua/plugins/completion.lua for blink.cmp completion engine.

Requirements:
- Use saghen/blink.cmp with version = "1.*"
- Event: InsertEnter
- Dependencies: rafamadriz/friendly-snippets, L3MON4D3/LuaSnip
- Keymaps:
  - <C-j> = select_next
  - <C-k> = select_prev
  - <C-y> = accept
  - <C-u> = scroll_documentation_up
  - <C-d> = scroll_documentation_down
- Sources: lsp, path, snippets, buffer
- Enable: ghost_text, documentation auto_show, signature help
- Follow lazy.nvim plugin spec format
```

#### Task A2: Create llama.vim config
```
Create lua/plugins/llm_autocomplete.lua for local AI completion.

Requirements:
- Use ggml-org/llama.vim
- Event: InsertEnter
- Auto-detect if llama-server is running:
  - On VimEnter, async check if http://127.0.0.1:8012 responds
  - Set vim.g.llama_enabled based on result
- vim.g.llama_config:
  - endpoint = "http://127.0.0.1:8012/infill"
  - auto_fim = true (only when enabled)
  - show_info = 1
- Add keymap <leader>,a to toggle vim.g.llama_enabled with notification
- Follow lazy.nvim plugin spec format
```

#### Task A3: Create direnv.vim config
```
Create lua/plugins/direnv.lua for project environment loading.

Requirements:
- Use direnv/direnv.vim
- lazy = false (must load early)
- priority = 90
- Simple config, direnv handles most things automatically
- Follow lazy.nvim plugin spec format
```

#### Task A4: Create trouble.nvim config
```
Create lua/plugins/diagnostics.lua for better diagnostics UI.

Requirements:
- Use folke/trouble.nvim
- cmd = "Trouble" (lazy load on command)
- opts:
  - focus = false
  - auto_preview = true
  - modes.symbols.win = { position = "right", width = 40 }
- Keymaps:
  - <leader>xx = Trouble diagnostics toggle
  - <leader>xX = Trouble diagnostics toggle filter.buf=0
  - <leader>xs = Trouble symbols toggle focus=false
  - <leader>xq = Trouble qflist toggle
- Follow lazy.nvim plugin spec format
```

#### Task A5: Create lazydev.nvim config
```
Create lua/plugins/lazydev.lua for Lua/Neovim development.

Requirements:
- Use folke/lazydev.nvim
- ft = "lua"
- opts.library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } }
- Follow lazy.nvim plugin spec format
```

#### Task A6: Create mini.nvim config
```
Create lua/plugins/mini.lua to consolidate utility plugins.

Requirements:
- Use echasnovski/mini.nvim
- event = VeryLazy
- In config function, setup these modules:
  1. mini.surround with mappings: gsa (add), gsd (delete), gsr (replace), gsf (find), gsF (find_left), gsh (highlight), gsn (update_n_lines)
  2. mini.comment (default config)
  3. mini.pairs (default config)
  4. mini.ai (default config for enhanced text objects)
- Add custom keymap to preserve <leader>/ for comment toggle:
  - Normal mode: toggle line comment
  - Visual mode: toggle selection comment
- Follow lazy.nvim plugin spec format
```

### Parallel Group B: Flake Modifications

#### Task B1: Update flake.nix inputs
```
Modify flake.nix to add new plugin inputs and remove deprecated ones.

ADD these inputs (follow existing pattern with .url and .flake = false):
- "nvim_plugin-saghen/blink.cmp"
- "nvim_plugin-folke/trouble.nvim"
- "nvim_plugin-echasnovski/mini.nvim"
- "nvim_plugin-folke/lazydev.nvim"
- "nvim_plugin-direnv/direnv.vim"
- "nvim_plugin-ggml-org/llama.vim"

REMOVE these inputs:
- "nvim_plugin-folke/neodev.nvim"
- "nvim_plugin-zbirenbaum/copilot.lua"
- "nvim_plugin-zbirenbaum/copilot-cmp"
- "nvim_plugin-CopilotC-Nvim/CopilotChat.nvim"
- "nvim_plugin-hrsh7th/nvim-cmp"
- "nvim_plugin-saadparwaiz1/cmp_luasnip"
- "nvim_plugin-hrsh7th/cmp-nvim-lsp"
- "nvim_plugin-hrsh7th/cmp-path"
- "nvim_plugin-hrsh7th/cmp-buffer"
- "nvim_plugin-numToStr/Comment.nvim"
- "nvim_plugin-JoosepAlviste/nvim-ts-context-commentstring"
- "nvim_plugin-tpope/vim-surround"
```

#### Task B2: Restructure flake.nix dependencies
```
Modify flake.nix runtimeDependencies to reduce bloat.

KEEP in runtimeDependenciesCore (add direnv):
- ripgrep, fd, tree-sitter, fzf, glow, curl, sshfs
- nixfmt-rfc-style, nil
- Add: direnv

CREATE new runtimeDependenciesCommon (formatters/linters often needed):
- stylua
- lua-language-server  
- nodePackages.prettier
- markdownlint-cli
- markdownlint-cli2

REDUCE runtimeDependenciesFull to only LSPs/tools that are truly "full":
- biome, svelte-check, rustywind, sql-formatter, qmlformat deps
- All LSPs: vscode-langservers-extracted, typescript-language-server, svelte-language-server, tailwindcss-language-server, eslint_d, python-lsp-server, rust-analyzer, marksman, taplo, yaml-language-server, lemminx, gopls
- typescript, nodejs_24, clang, rust toolchain

Update createNeovim to use:
- Core always via --suffix
- Common always via --suffix (after core)
- Full only when full=true via --suffix (last)
```

### Sequential Group C: LSP Config Updates (After Group A)

#### Task C1: Update lsp.lua
```
Modify lua/plugins/lsp.lua with the following changes:

1. Remove neodev.nvim dependency - delete from dependencies list

2. Update capabilities for blink.cmp:
   - Remove: require('cmp_nvim_lsp').default_capabilities()
   - Keep: vim.lsp.protocol.make_client_capabilities()
   - Note: blink.cmp auto-registers its capabilities

3. Simplify lua_ls config:
   - Remove manual workspace.library settings (lazydev handles this)
   - Keep: settings.Lua.diagnostics.globals = { "vim", "NIX", "U", "hs" }

4. Add smart LSP detection (in the config function):
   - Create expected_lsp table mapping filetypes to binary names
   - Add FileType autocmd that checks vim.fn.executable
   - Show vim.notify warning if LSP not found (debounced, 500ms delay)
   - Warning message: "LSP '{name}' for {ft} not found. Add to project devShell."
```

### Sequential Group D: Cleanup (After Groups A, B, C)

#### Task D1: Delete replaced plugin files
```
Delete the following files that are replaced by mini.nvim:
- lua/plugins/surround.lua
- lua/plugins/comments_support.lua
- lua/plugins/cmp_autocompletion.lua
```

#### Task D2: Rename files for consistency
```
Rename:
- lua/plugins/conform_formatter.lua -> lua/plugins/formatting.lua
- lua/plugins/lint.lua -> lua/plugins/linting.lua
```

#### Task D3: Update which-key config
```
Modify lua/plugins/whichkey.lua:
- Add group for trouble: { "<leader>x", group = "Trouble/Diagnostics" }
- Add group for llm toggle if not exists: under <leader>, group
```

### Sequential Group E: Documentation (After All)

#### Task E1: Update README.md
```
Update README.md with:

1. Update requirements section:
   - Neovim >= 0.11 (for native LSP config)
   - Note about direnv for project LSP support

2. Add "Project LSP Setup" section:
   - Explain that most LSPs come from project devShells via direnv
   - Example flake.nix devShell with LSPs
   - Note about core LSPs always available (lua, nix)

3. Add "Local AI Completion" section:
   - Explain llama.vim integration
   - How to run llama-server with sweep-next-edit-1.5B
   - Toggle with <leader>,a
   - Note: auto-detects if server running

4. Remove:
   - Copilot mentions
   - Any outdated plugin references

5. Update NOTES/TODOS section:
   - Remove completed items
   - Add any new future ideas
```

---

## Dependency Graph

```
Group A (Parallel - No deps)     Group B (Parallel - No deps)
├── A1: completion.lua           ├── B1: flake inputs
├── A2: llm_autocomplete.lua     └── B2: flake deps
├── A3: direnv.lua
├── A4: diagnostics.lua
├── A5: lazydev.lua
└── A6: mini.lua
        │                                │
        └────────────┬───────────────────┘
                     ▼
              Group C (Sequential)
              └── C1: Update lsp.lua
                     │
                     ▼
              Group D (Sequential)
              ├── D1: Delete old files
              ├── D2: Rename files
              └── D3: Update which-key
                     │
                     ▼
              Group E (Sequential)
              └── E1: Update README
```

## Execution Order

1. **Run in parallel**: A1, A2, A3, A4, A5, A6, B1, B2
2. **After step 1**: C1
3. **After step 2**: D1, D2, D3 (can be parallel)
4. **After step 3**: E1
5. **Manual testing**: Verify nix and non-nix modes work
