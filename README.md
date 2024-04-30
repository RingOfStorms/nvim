# NVIM config

## Running

### With Nix (Recommended)
nix run "."

### On any system

Enture all prequisites are installed:
- neovim
- Evertying listed in flake.nix `runtime dependencies` variable near the top of the file
    - These must be available on the path
    - Treesitter/Lazy/Mason will install all other requirements needed on other systems

Install neovim config (backup old version first if present):
```
git clone https://github.com/RingOfStorms/nvim ~/.config/nvim
nvim --headless "+Lazy! sync" +qa
```



## NOTES/TODOS


- Checkout cargo-bloat, cargo-cache, cargo-outdated - memcache sccache
- For scratches, just make an input box for custom extension rather than predefined list
- for find files, ignore git, capital F for find all

- plugins to check out:
     - https://github.com/declancm/cinnamon.nvim
     - https://github.com/folke/noice.nvim
