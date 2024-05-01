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

- Checkout cargo-bloat, cargo-cache, cargo-outdated - memcache sccache
- For scratches, just make an input box for custom extension rather than predefined list
- for find files, ignore git, capital F for find all
- better copilot alternatives? Local LLM usage only? etc?
- generate command, like scratch open a popup of things that can be generated. UUID/other stuff?
   - https://github.com/mawkler/nvim/blob/06cde9dbaedab2bb36c06025c07589c93d2c6d6b/lua/configs/luasnip.lua#L37-L50
- TODO learn more about augroup in autocommands.
- make my own session saving impl
  - Only save visible buffers/tabs/splits
  - per branch per directory
  - something like https://github.com/gennaro-tedesco/nvim-possession/tree/main but fully managed


- plugins to install:
  - uga-rosa/ccc.nvim - color picker for hex codes etc
  - zbirenbaum/copilot.lua
    - Does github's work for me now? github/copilot.vim
    - zbirenbaum/copilot-cmp
  - voldikss/vim-floaterm
  - GIT
    - lewis6991/gitsigns.nvim
    - Neogitorg/neogit ??? remove? I dont use this much...
    - kdheepak/lazygit.nvim ?? remove?
    - sindrets/diffview.nvim ? as long as this works without the above.
  - rest-nvim/rest.nvim - http curl commands
    - TODO I want a better alternative to this. One that shows streaming responses/curl as is. Can I just run curl myself easily?
  - RRethy/vim-illuminate - show token under cursor throughout file
  - lukas-reineke/indent-blankline.nvim - indent lines
    - TODO figure out tabs vs spaces thing with arrows vs bars.
  - LSP stuff... figure out from scratch using kickstart/lazynvim as an example
    - rust, ts, js, nix, lua, 
    - lvimuser/lsp-inlayhints.nvim L3MON4D3/LuaSnip hrsh7th/nvim-cmp williamboman/mason.nvim folke/neodev.nvim williamboman/mason-lspconfig.nvim neovim/nvim-lspconfig simrat39/rust-tools.nvim Saecki/crates.nvim
    - how cna we do language specific tooling per project integrated with neovim here? Like different rust versions in current shell etc?
    - MASON when not nix, otherwise yes
  - lnc3l0t/glow.nvim - markdown preview
  - null_ls replacement?? need a formater replacement, diff between lsp reformat?
    - cspell? vs built in spell check?
    - Lets use https://github.com/mfussenegger/nvim-lint
  - Almo7aya/openingh.nvim
  - tpope/vim-surround
  - nvim-telescope/telescope-file-browser.nvim ?? do I want to keep this?
  - johmsalas/text-case.nvim
  - nvim-treesitter/nvim-treesitter
  - mbbill/undotree
  - nvim-lua/plenary.nvim
  - folke/which-key.nvim

- check out
  - https://github.com/onsails/lspkind.nvim
  - https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-align.md

- plugins I decided to remove from my old config
  - jinh0/eyeliner.nvim
  - David-Kunz/gen.nvim - ollama integration
  - Neogitorg/neogit ??
  - kdheepak/lazygit.nvim ??
  - null_ls
