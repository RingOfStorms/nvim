{
  description = "RingOfStorms's Neovim configuration using nix flake for portability";
  # Nixpkgs / NixOS version to use.
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";


    # Names should always be `nvim_plugin-[lazy plugin name]`
    "nvim_plugin-folke/lazy.nvim" = {
      url = "github:folke/lazy.nvim";
      flake = false;
    };
    "nvim_plugin-nvim-lua/plenary.nvim" = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
    "nvim_plugin-catppuccin/nvim" = {
      url = "github:catppuccin/nvim";
      flake = false;
    };
    "nvim_plugin-Pocco81/auto-save.nvim" = {
      url = "github:Pocco81/auto-save.nvim";
      flake = false;
    };
    "nvim_plugin-chrisgrieser/nvim-early-retirement" = {
      url = "github:chrisgrieser/nvim-early-retirement";
      flake = false;
    };
    "nvim_plugin-MunifTanjim/nui.nvim" = {
      url = "github:MunifTanjim/nui.nvim";
      flake = false;
    };
    "nvim_plugin-rcarriga/nvim-notify" = {
      url = "github:rcarriga/nvim-notify";
      flake = false;
    };
    "nvim_plugin-folke/noice.nvim" = {
      url = "github:folke/noice.nvim";
      flake = false;
    };
    "nvim_plugin-declancm/cinnamon.nvim" = {
      url = "github:declancm/cinnamon.nvim";
      flake = false;
    };
    "nvim_plugin-nvim-lualine/lualine.nvim" = {
      url = "github:nvim-lualine/lualine.nvim";
      flake = false;
    };
    "nvim_plugin-folke/which-key.nvim" = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };
    "nvim_plugin-nvim-telescope/telescope.nvim" = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
    "nvim_plugin-nvim-telescope/telescope-fzf-native.nvim" = {
      url = "github:nvim-telescope/telescope-fzf-native.nvim";
      flake = false;
    };
    "nvim_plugin-nvim-telescope/telescope-ui-select.nvim" = {
      url = "github:nvim-telescope/telescope-ui-select.nvim";
      flake = false;
    };
    "nvim_plugin-JoosepAlviste/nvim-ts-context-commentstring" = {
      url = "github:JoosepAlviste/nvim-ts-context-commentstring";
      flake = false;
    };
    "nvim_plugin-preservim/nerdcommenter" = {
      url = "github:preservim/nerdcommenter";
      flake = false;
    };
    "nvim_plugin-windwp/nvim-ts-autotag" = {
      url = "github:windwp/nvim-ts-autotag";
      flake = false;
    };
    "nvim_plugin-rmagatti/auto-session" = {
      url = "github:rmagatti/auto-session";
      flake = false;
    };
    "nvim_plugin-nvim-tree/nvim-web-devicons" = {
      url = "github:nvim-tree/nvim-web-devicons";
      flake = false;
    };
    "nvim_plugin-nvim-tree/nvim-tree.lua" = {
      url = "github:nvim-tree/nvim-tree.lua";
      flake = false;
    };
    "nvim_plugin-uga-rosa/ccc.nvim" = {
      url = "github:uga-rosa/ccc.nvim";
      flake = false;
    };
    "nvim_plugin-voldikss/vim-floaterm" = {
      url = "github:voldikss/vim-floaterm";
      flake = false;
    };
    "nvim_plugin-lewis6991/gitsigns.nvim" = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
    "nvim_plugin-sindrets/diffview.nvim" = {
      url = "github:sindrets/diffview.nvim";
      flake = false;
    };
    "nvim_plugin-RRethy/vim-illuminate" = {
      url = "github:RRethy/vim-illuminate";
      flake = false;
    };
    "nvim_plugin-lukas-reineke/indent-blankline.nvim" = {
      url = "github:lukas-reineke/indent-blankline.nvim";
      flake = false;
    };
    "nvim_plugin-lnc3l0t/glow.nvim" = {
      url = "github:lnc3l0t/glow.nvim";
      flake = false;
    };
    "nvim_plugin-Almo7aya/openingh.nvim" = {
      url = "github:Almo7aya/openingh.nvim";
      flake = false;
    };
    "nvim_plugin-tpope/vim-surround" = {
      url = "github:tpope/vim-surround";
      flake = false;
    };
    "nvim_plugin-johmsalas/text-case.nvim" = {
      url = "github:johmsalas/text-case.nvim";
      flake = false;
    };
    "nvim_plugin-mbbill/undotree" = {
      url = "github:mbbill/undotree";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... } @ inputs:
    # Takes all top level attributes and changes them to `attribute.${system} = old value`
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = nixpkgs.lib;

        nonFlakePluginPaths = {
          "nvim_plugin-nvim-treesitter/nvim-treesitter" = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
        };
        # This will be how we put any nix related stuff into our lua config
        luaNixGlobal = "NIX=" + lib.generators.toLua { multiline = false; indent = false; } ({
          storePath = "${./.}";
          # This will look at all inputs and grab any prefixed with `nvim_plugin-`
          pluginPaths = builtins.foldl'
            (dirs: name:
              {
                "${name}" = inputs.${name}.outPath;
              } // dirs)
            nonFlakePluginPaths
            (builtins.filter
              (n: builtins.substring 0 12 n == "nvim_plugin-")
              (builtins.attrNames inputs));
        });

        runtimeDependencies = with pkgs; [
          ripgrep # search
          fd # search
          fzf # search fuzzy
          # curl # http requests
          tree-sitter
          glow # markdown renderer
          # nodePackages.cspell
        ];
      in
      {
        packages = {
          default = self.packages.${system}.neovim;
          neovim =
            (pkgs.wrapNeovimUnstable
              pkgs.neovim-unwrapped
              (pkgs.neovimUtils.makeNeovimConfig {
                withPython3 = false;
                customRC = ''
                  lua ${luaNixGlobal}
                  luafile ${./.}/init.lua
                  set runtimepath^=${builtins.concatStringsSep "," (builtins.attrValues pkgs.vimPlugins.nvim-treesitter.grammarPlugins)}
                '';
              })
            ).overrideAttrs
              (old: {
                generatedWrapperArgs = old.generatedWrapperArgs or [ ] ++ [
                  # Add runtime dependencies to neovim path
                  "--prefix"
                  "PATH"
                  ":"
                  "${lib.makeBinPath runtimeDependencies}"
                  # Set the LAZY env path to the nix store, see init.lua for how it is used
                  "--set"
                  "LAZY"
                  "${inputs."nvim_plugin-folke/lazy.nvim"}"
                  # Don't use default directories to not collide with another neovim config
                  # All things at runtime should be deletable since we are using nix to handle downloads and bins.
                  "--set"
                  "XDG_CONFIG_HOME"
                  "/tmp/nvim_flaked/config"
                  "--set"
                  "XDG_DATA_HOME"
                  "/tmp/nvim_flaked/share"
                  "--set"
                  "XDG_RUNTIME_DIR"
                  "/tmp/nvim_flaked/run"
                  "--set"
                  "XDG_STATE_HOME"
                  "/tmp/nvim_flaked/state"
                ];
              });
        };
      });

}


