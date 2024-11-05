# NVIM config

Goals:

- Works with or without nix
- LSP integration with the current project's settings if available

Old pre nix config: https://git.joshuabell.xyz/nvim/~files/40eadc9b714fa29c5b28aca49f77c1ea62141763 for reference

## Running

### With Nix

```sh
nix run 'github:ringofstorms/nvim'
```

in NixOS

```nix
-- in flake.nix#inputs
ringofstorms-nvim = {
  url = "github:RingOfStorms/nvim";
  inputs.nixpkgs.follows = "nixpkgs";
};
-- in nix module
environment.systemPackages = with pkgs; [
  ringofstorms-nvim.packages.${settings.system.system}.neovim
];
```

### Without Nix

TODO update this section

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

- See what linters/formaters to add or are the LSP's enough?
- CSPELL/spelling linter

FUTURE

- Make a new HTTP plugin for running curl commands from .http files
  - similar to est-nvim/rest.nvim but support streaming etc and show command output
- Execute selected command and open output into a buffer/popup window? <leader>cx
- generate command, like scratch open a popup of things that can be generated. UUID/other stuff?
- <https://gilt hub.com/mawkler/nvim/blob/06cde9dbaedab2bb36c06025c07589c93d2c6d6b/lua/configs/luasnip.lua#L37-L50>
- Checkout cargo-bloat, cargo-cache, cargo-outdated - memcache sccache
- For scratches, just make an input box for custom extension rather than predefined list
- freaking learn to use surround more often <https://github.com/tpope/vim-surround/tree/master>
- make my own session saving impl
  - Only save visible buffers/tabs/splits
  - per branch per directory
  - something like <https://github.com/gennaro-tedesco/nvim-possession/tree/main> but fully managed
- copilot? local llm?
- check out
  - <https://github.com/onsails/lspkind.nvim>
  - <https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-align.md>
  - <https://github.com/tpope/vim-abolish>
