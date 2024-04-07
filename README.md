# NVIM config

## Running

### With Nix (Recommended)


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
