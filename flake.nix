{
  description = "RingOfStorms's Neovim configuration using nix flake for portability";
  # Nixpkgs / NixOS version to use.
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Names should always be `nvim_plugin-[lazy plugin name]`
    "nvim_plugin-folke/lazy.nvim" = {
      # plugin manager and loader for fast bootup
      url = "github:folke/lazy.nvim";
      flake = false;
    };
    "nvim_plugin-catppuccin/nvim" = {
      # color scheme
      url = "github:catppuccin/nvim";
      flake = false;
    };
    "nvim_plugin-nvim-tree/nvim-web-devicons" = {
      url = "github:nvim-tree/nvim-web-devicons";
      flake = false;
    };

    # "nvim_plugin-nvim-treesitter/nvim-treesitter" NOTE: done using nix pkgs since it is packaged with all grammars
    "nvim_plugin-nvim-lua/plenary.nvim" = {
      # utils used by many plugins
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
    "nvim_plugin-MunifTanjim/nui.nvim" = {
      # component library util
      url = "github:MunifTanjim/nui.nvim";
      flake = false;
    };

    "nvim_plugin-rmagatti/auto-session" = {
      # Restore sessions
      url = "github:rmagatti/auto-session";
      flake = false;
    };
    "nvim_plugin-chrisgrieser/nvim-early-retirement" = {
      # Close buffers in background if unused
      url = "github:chrisgrieser/nvim-early-retirement";
      flake = false;
    };
    "nvim_plugin-rcarriga/nvim-notify" = {
      url = "github:rcarriga/nvim-notify";
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
      # popup search menu
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
    "nvim_plugin-nvim-telescope/telescope-fzf-native.nvim" = {
      # fzf integration for telescope
      url = "github:nvim-telescope/telescope-fzf-native.nvim";
      flake = false;
    };
    "nvim_plugin-nvim-telescope/telescope-ui-select.nvim" = {
      # telescope used for selections in ui
      url = "github:nvim-telescope/telescope-ui-select.nvim";
      flake = false;
    };
    "nvim_plugin-nvim-telescope/telescope-file-browser.nvim" = {
      # telescope based file browser
      url = "github:nvim-telescope/telescope-file-browser.nvim";
      flake = false;
    };

    "nvim_plugin-nvim-tree/nvim-tree.lua" = {
      # tree based file browser
      url = "github:nvim-tree/nvim-tree.lua";
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

    "nvim_plugin-uga-rosa/ccc.nvim" = {
      url = "github:uga-rosa/ccc.nvim";
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
    "nvim_plugin-tpope/vim-sleuth" = {
      url = "github:tpope/vim-sleuth";
      flake = false;
    };

    "nvim_plugin-mfussenegger/nvim-lint" = {
      url = "github:mfussenegger/nvim-lint";
      flake = false;
    };
    "nvim_plugin-stevearc/conform.nvim" = {
      url = "github:stevearc/conform.nvim";
      flake = false;
    };

    "nvim_plugin-j-hui/fidget.nvim" = {
      # TODO move near lsp
      # LSP loading status messages
      url = "github:j-hui/fidget.nvim";
      flake = false;
    };
    "nvim_plugin-neovim/nvim-lspconfig" = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };
    "nvim_plugin-hrsh7th/nvim-cmp" = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    "nvim_plugin-L3MON4D3/LuaSnip" = {
      url = "github:L3MON4D3/LuaSnip";
      flake = false;
    };
    "nvim_plugin-saadparwaiz1/cmp_luasnip" = {
      url = "github:saadparwaiz1/cmp_luasnip";
      flake = false;
    };
    "nvim_plugin-hrsh7th/cmp-nvim-lsp" = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    "nvim_plugin-hrsh7th/cmp-path" = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    "nvim_plugin-hrsh7th/cmp-buffer" = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    "nvim_plugin-zbirenbaum/copilot-cmp" = {
      url = "github:zbirenbaum/copilot-cmp";
      flake = false;
    };
    "nvim_plugin-zbirenbaum/copilot.lua" = {
      url = "github:zbirenbaum/copilot.lua";
      flake = false;
    };
    "nvim_plugin-folke/neodev.nvim" = {
      url = "github:folke/neodev.nvim";
      flake = false;
    };
    "nvim_plugin-Saecki/crates.nvim" = {
      url = "github:Saecki/crates.nvim";
      flake = false;
    };
    "nvim_plugin-lvimuser/lsp-inlayhints.nvim" = {
      url = "github:lvimuser/lsp-inlayhints.nvim";
      flake = false;
    };
    "nvim_plugin-rafamadriz/friendly-snippets" = {
      url = "github:rafamadriz/friendly-snippets";
      flake = false;
    };
  };
  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      # Anytime there is a huge breaking change that old state files wont
      # work then we make a new version name. Helps separate any files and
      # "version" my neovim flake
      # ==================
      version = "hydrogen";
      # ===================

      inherit (nixpkgs) lib;
      withSystem =
        f:
        lib.fold lib.recursiveUpdate { } (
          map f [
            "x86_64-linux"
            "x86_64-darwin"
            "aarch64-linux"
            "aarch64-darwin"
          ]
        );
    in
    # Takes all top level attributes and changes them to `attribute.${system} = old value`
    withSystem (
      system:
      let
        # pkgs = nixpkgs.legacyPackages.${system};
        overlays = [ (import inputs.rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };

        lazyPath = inputs."nvim_plugin-folke/lazy.nvim";
        nixPkgsPlugins = with pkgs.vimPlugins; {
          "nvim_plugin-nvim-treesitter/nvim-treesitter" = nvim-treesitter.withAllGrammars;
        };

        # This will be how we put any nix related stuff into our lua config
        luaNixGlobal =
          "NIX="
          +
            lib.generators.toLua
              {
                multiline = false;
                indent = false;
              }
              ({
                storePath = "${./.}";
                # This will look at all inputs and grab any prefixed with `nvim_plugin-`
                pluginPaths =
                  builtins.foldl' (dirs: name: { "${name}" = inputs.${name}.outPath; } // dirs) nixPkgsPlugins
                    (builtins.filter (n: builtins.substring 0 12 n == "nvim_plugin-") (builtins.attrNames inputs));
              });

        runtimeDependencies = with pkgs; [
          # tools
          ripgrep # search
          fd # search
          fzf # search fuzzy
          tree-sitter
          glow # markdown renderer
          curl # http requests
          # nodePackages.cspell TODO
        ];

        defaultRuntimeDependencies = with pkgs; [
          # linters
          markdownlint-cli
          luajitPackages.luacheck
          biome # (t|s)j[x]
          # formatters
          stylua
          nixfmt-rfc-style
          nodePackages.prettier
          rustywind
          markdownlint-cli2
          # LSPs
          nil # nix
          lua-language-server
          vscode-langservers-extracted # HTML/CSS/JSON/ESLint
          nodePackages.typescript-language-server
          tailwindcss-language-server
          pyright
          rust-analyzer
          marksman # markdown
          taplo # toml
          yaml-language-server
          lemminx # xml
          # Other
          # typescript
          nodejs_20
          clang
          zig
          (pkgs.rust-bin.stable.latest.default.override {
            extensions = [
              "rust-src"
              "rust-analyzer"
            ];
          })
        ];
      in
      {
        packages.${system} = {
          default = self.packages.${system}.neovim;
          neovim =
            (pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (
              pkgs.neovimUtils.makeNeovimConfig {
                withPython3 = false;
                customRC = ''
                  lua ${luaNixGlobal}
                  luafile ${./.}/init.lua
                  set runtimepath^=${builtins.concatStringsSep "," (builtins.attrValues pkgs.vimPlugins.nvim-treesitter.grammarPlugins)}
                '';
              }
            )).overrideAttrs
              (old: {
                generatedWrapperArgs = old.generatedWrapperArgs or [ ] ++ [
                  # Add runtime dependencies to neovim path
                  "--prefix"
                  "PATH"
                  ":"
                  "${lib.makeBinPath runtimeDependencies}"
                  # Some we will suffix so we pick up the local dev shell intead and default to these otherwise
                  "--suffix"
                  "PATH"
                  ":"
                  "${lib.makeBinPath defaultRuntimeDependencies}"
                  # Set the LAZY env path to the nix store, see init.lua for how it is used
                  "--set"
                  "LAZY"
                  "${lazyPath}"
                  # Don't use default directories to not collide with another neovim config
                  # All things at runtime should be deletable since we are using nix to handle downloads and bins
                  # so I've chosen to put everything into the local state directory.
                  "--run"
                  ''export NVIM_FLAKE_BASE_DIR="''${XDG_STATE_HOME:-$HOME/.local/state}"''
                  "--run"
                  ''export XDG_CONFIG_HOME="$NVIM_FLAKE_BASE_DIR/nvim_ringofstorms_${version}/config"''
                  "--run"
                  ''export XDG_DATA_HOME="$NVIM_FLAKE_BASE_DIR/nvim_ringofstorms_${version}/share"''
                  "--run"
                  ''export XDG_RUNTIME_DIR="$NVIM_FLAKE_BASE_DIR/nvim_ringofstorms_${version}/run"''
                  "--run"
                  ''export XDG_STATE_HOME="$NVIM_FLAKE_BASE_DIR/nvim_ringofstorms_${version}/state"''
                  "--run"
                  ''export XDG_CACHE_HOME="$NVIM_FLAKE_BASE_DIR/nvim_ringofstorms_${version}/cache"''
                  "--run"
                  ''export TESTASDASD="${lib.concatStringsSep "|" (lib.attrValues pkgs.vimPlugins.nvim-treesitter.grammarPlugins)}"''
                ];
              });
        };
      }
    );
}
