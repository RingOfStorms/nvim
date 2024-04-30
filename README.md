# NVIM config

Goals:
- Works with or without nix

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

- plugins to install:
  - pocco81/auto-save.nvim
  - folke/noice.nvim - messages/cmdline/popupmenu updates
  - rmagatti/auto-session - session management
    - TODO look for alternatives? I am not a huge fan of this as it causes some issues on startup sometimes. I really only care about window placements and I want the rest to load naturally
  - preservim/nerdcommenter - [un]comment support
  - uga-rosa/ccc.nvim - color picker for hex codes etc
  - zbirenbaum/copilot.lua
    - Does github's work for me now? github/copilot.vim
    - zbirenbaum/copilot-cmp
  - chrisgrieser/nvim-early-retirement - auto close buffers
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
  - nvim-lualine/lualine.nvim
    - TODO look at other buffer lines, is this still the best? What do others use?
  - LSP stuff... figure out from scratch using kickstart/lazynvim as an example
    - rust, ts, js, nix, lua, 
    - lvimuser/lsp-inlayhints.nvim L3MON4D3/LuaSnip hrsh7th/nvim-cmp williamboman/mason.nvim folke/neodev.nvim williamboman/mason-lspconfig.nvim neovim/nvim-lspconfig simrat39/rust-tools.nvim Saecki/crates.nvim
    - how cna we do language specific tooling per project integrated with neovim here? Like different rust versions in current shell etc?
    - MASON when not nix, otherwise yes
  - lnc3l0t/glow.nvim - markdown preview
  - null_ls replacement?? need a formater replacement, diff between lsp reformat?
    - cspell? vs built in spell check?
  - Almo7aya/openingh.nvim
  - tpope/vim-surround
  - nvim-telescope/telescope-file-browser.nvim ?? do I want to keep this?
  - nvim-telescope/telescope.nvim
    - nvim-telescope/telescope-fzf-native.nvim
    - nvim-telescope/telescope-ui-select.nvim (use this with scratch files?)
  - johmsalas/text-case.nvim
  - nvim-treesitter/nvim-treesitter
  - mbbill/undotree
  - nvim-lua/plenary.nvim
  - rcarriga/nvim-notify ??? is this replaced by noice??
  - folke/which-key.nvim

- check out
  - https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-bufremove.md
    - OR https://github.com/famiu/bufdelete.nvim
  - https://github.com/onsails/lspkind.nvim
  - declancm/cinnamon.nvim - smooth scroll effect
  - https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-align.md

- plugins I decided to remove from my old config
  - jinh0/eyeliner.nvim
  - David-Kunz/gen.nvim - ollama integration
  - Neogitorg/neogit ??
  - kdheepak/lazygit.nvim ??
  - null_ls
