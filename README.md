# NVIM config

Goals:

- Works with or without nix
- LSP integration with the current project's settings if available

## Running

### With Nix

```sh
nix run "."
```

### Without Nix

- Must have all required programs installed and available on path
  - neovim >= 0.5
  - Evertying listed in flake.nix `runtime dependencies` variable near the top of the file
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

## NOTES/TODOS

FUTURE
- Make my own session save plugin, I ONLY want window positioning/open buffers saved nothing else.
- Make a new HTTP plugin for running curl commands from .http files
  - similar to est-nvim/rest.nvim but support streaming etc and show command output
- Execute selected command and open output into a buffer/popup window? <leader>cx
- generate command, like scratch open a popup of things that can be generated. UUID/other stuff?
- https://github.com/mawkler/nvim/blob/06cde9dbaedab2bb36c06025c07589c93d2c6d6b/lua/configs/luasnip.lua#L37-L50

- TODO figure out tabs vs spaces thing with arrows vs bars. indent plugin...
- Checkout cargo-bloat, cargo-cache, cargo-outdated - memcache sccache
- For scratches, just make an input box for custom extension rather than predefined list
- TODO learn more about augroup in autocommands, apply to any other auto commands I have
- freaking learn to use surround more often https://github.com/tpope/vim-surround/tree/master
- make my own session saving impl
  - Only save visible buffers/tabs/splits
  - per branch per directory
  - something like https://github.com/gennaro-tedesco/nvim-possession/tree/main but fully managed

- copilot? local llm?
- lsp
- null_ls replacements

- plugins to install:
  - LSP stuff... figure out from scratch using kickstart/lazynvim as an example
    - rust, ts, js, nix, lua, 
    - lvimuser/lsp-inlayhints.nvim L3MON4D3/LuaSnip hrsh7th/nvim-cmp williamboman/mason.nvim folke/neodev.nvim williamboman/mason-lspconfig.nvim neovim/nvim-lspconfig simrat39/rust-tools.nvim Saecki/crates.nvim
    - how cna we do language specific tooling per project integrated with neovim here? Like different rust versions in current shell etc?
    - MASON when not nix, otherwise yes
  - null_ls replacement?? need a formater replacement, diff between lsp reformat?
    - cspell? vs built in spell check?
    - Lets use https://github.com/mfussenegger/nvim-lint

- check out
  - https://github.com/onsails/lspkind.nvim
  - https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-align.md
  - https://github.com/tpope/vim-abolish
