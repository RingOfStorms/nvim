# NVIM config

Goals:

- Works with or without nix
- LSP integration with the current project's settings if available
- Lean and fast startup with lazy loading
- Project-driven tooling via direnv and devShells

## Running

### With Nix

```sh
nix run git+https://git.joshuabell.xyz/ringofstorms/nvim
```

in NixOS

```nix
-- in flake.nix#inputs
ringofstorms-nvim = {
  url = "git+https://git.joshuabell.xyz/nvim";
};
-- in nix module
environment.systemPackages = with pkgs; [
  ringofstorms-nvim.packages.${settings.system.system}.neovim
];
```

### Without Nix

- Must have all required programs installed and available on path
  - neovim >= 0.11 (required for native LSP config)
  - Everything listed in flake.nix `runtimeDependenciesCore` variable
    - These must be available on the path
    - Treesitter/Lazy/Mason will install all other requirements needed on other systems

```sh
git clone https://github.com/RingOfStorms/nvim ~/.config/nvim
nvim --headless "+Lazy! sync" +qa
```

Backup existing config:

```sh
DATE=$(date +"%Y%m%d")
mv ~/.config/nvim ~/.config/nvim_$DATE.bak
mv ~/.local/share/nvim ~/.local/share/nvim_$DATE.bak
mv ~/.local/state/nvim ~/.local/state/nvim_$DATE.bak
```

or remove existing config:

```sh
rm -rf ~/.config/nvim 
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim 
```

## Project LSP Setup

This config uses a "lean core" approach where most LSPs come from your project's devShell via direnv.

### How It Works

1. **Core tools** (ripgrep, fd, lua-language-server, nil, etc.) are always available
2. **direnv.vim** automatically loads your project's `.envrc` / `devShell` environment
3. **Smart detection** warns you if an expected LSP is missing for a filetype

### Example Project flake.nix

```nix
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  
  outputs = { nixpkgs, ... }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = with pkgs; [
          # Your project's LSPs
          typescript-language-server
          nodePackages.prettier
          eslint_d
          
          # Your project's tools
          nodejs_22
          pnpm
        ];
      };
    };
}
```

Then create `.envrc`:
```sh
use flake
```

And run `direnv allow` in your project directory.

## Local AI Autocomplete

This config supports local AI-powered code completion via [llama.vim](https://github.com/ggml-org/llama.vim).

### Setup

1. Install llama.cpp:
   ```sh
   # macOS
   brew install llama.cpp
   
   # Or build from source
   git clone https://github.com/ggml-org/llama.cpp
   cd llama.cpp && make
   ```

2. Download a FIM-capable model (e.g., sweep-next-edit-1.5B):
   ```sh
   # From HuggingFace
   wget https://huggingface.co/sweepai/sweep-next-edit-1.5B-GGUF/resolve/main/sweep-next-edit-Q8_0.gguf
   ```

3. Start llama-server:
   ```sh
   llama-server -m sweep-next-edit-Q8_0.gguf --port 8012 --fim-qwen-7b-default
   ```

4. Neovim will auto-detect the server and enable completions

### Usage

- **Tab** - Accept completion
- **Shift-Tab** - Accept first line only
- **Ctrl-F** - Toggle FIM manually
- **`<leader>,a`** - Toggle AI autocomplete on/off

### Recommended Models by VRAM

| VRAM | Recommended Model |
|------|-------------------|
| >64GB | qwen2.5-coder-32b |
| >16GB | qwen2.5-coder-7b |
| <16GB | qwen2.5-coder-3b |
| <8GB | sweep-next-edit-1.5b |

## Key Plugins

| Category | Plugin | Description |
|----------|--------|-------------|
| Completion | blink.cmp | Fast async completion with LSP, snippets, buffer |
| LSP | nvim-lspconfig | Native LSP configurations |
| Diagnostics | trouble.nvim | Pretty diagnostics and quickfix lists |
| Formatting | conform.nvim | Fast formatter integration |
| Linting | nvim-lint | Async linter integration |
| AI | llama.vim | Local LLM code completion |
| Utilities | mini.nvim | Surround, comment, pairs, text objects |
| Files | nvim-tree, telescope | File browsing and fuzzy finding |

## Keybindings

### LSP
- `gd` - Go to definition
- `gr` - Go to references
- `gI` - Go to implementation
- `K` - Hover documentation
- `<leader>la` - Code action
- `<leader>lr` - Rename

### Diagnostics (Trouble)
- `<leader>xx` - Toggle diagnostics
- `<leader>xX` - Buffer diagnostics only
- `<leader>xs` - Document symbols
- `<leader>xq` - Quickfix list

### Comments (mini.comment)
- `gc{motion}` - Toggle comment
- `gcc` - Toggle line comment
- `<leader>/` - Toggle comment (preserved binding)

### Surround (mini.surround)
- `gsa{motion}{char}` - Add surrounding
- `gsd{char}` - Delete surrounding
- `gsr{old}{new}` - Replace surrounding

## NOTES/TODOS

- CSPELL/spelling linter
- Consider mini-align for alignment

FUTURE

- Make a new HTTP plugin for running curl commands from .http files
  - similar to rest-nvim/rest.nvim but support streaming etc and show command output
- generate command, like scratch open a popup of things that can be generated. UUID/other stuff?
- Checkout cargo-bloat, cargo-cache, cargo-outdated - memcache sccache
- For scratches, just make an input box for custom extension rather than predefined list
- check out
  - <https://github.com/tpope/vim-abolish>
