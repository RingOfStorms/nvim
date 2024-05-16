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
    # Only need to add plugins as flake inputs if they are:
    # - Missing in nixpkgs
    # - We want to pin a specific version diverging from nixpkgs channel
    "nvim_plugin-chrisgrieser/nvim-early-retirement" = {
      url = "github:chrisgrieser/nvim-early-retirement";
      flake = false;
    };
    "nvim_plugin-folke/noice.nvim" = {
      url = "github:folke/noice.nvim/v2.0.3";
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

        # Plugins provided in nixpkgs, match the naming scheme above for keys
        lazyPath = pkgs.vimPlugins.lazy-nvim;
        nixPkgsPlugins = with pkgs.vimPlugins; {
          "nvim_plugin-folke/lazy.nvim" = lazyPath;
          "nvim_plugin-nvim-treesitter/nvim-treesitter" = nvim-treesitter.withAllGrammars;
          "nvim_plugin-nvim-lua/plenary.nvim" = plenary-nvim;
          "nvim_plugin-catppuccin/nvim" = catppuccin-nvim;
          "nvim_plugin-MunifTanjim/nui.nvim" = nui-nvim;
          "nvim_plugin-rcarriga/nvim-notify" = nvim-notify;
          # "nvim_plugin-folke/noice.nvim" = noice-nvim;
          "nvim_plugin-nvim-lualine/lualine.nvim" = lualine-nvim;
          "nvim_plugin-folke/which-key.nvim" = which-key-nvim;
          "nvim_plugin-nvim-telescope/telescope.nvim" = telescope-nvim;
          "nvim_plugin-nvim-telescope/telescope-fzf-native.nvim" = telescope-fzf-native-nvim;
          "nvim_plugin-nvim-telescope/telescope-ui-select.nvim" = telescope-ui-select-nvim;
          "nvim_plugin-JoosepAlviste/nvim-ts-context-commentstring" = nvim-ts-context-commentstring;
          "nvim_plugin-preservim/nerdcommenter" = nerdcommenter;
          "nvim_plugin-windwp/nvim-ts-autotag" = nvim-ts-autotag;
          "nvim_plugin-rmagatti/auto-session" = auto-session;
          "nvim_plugin-nvim-tree/nvim-web-devicons" = nvim-web-devicons;
          "nvim_plugin-nvim-tree/nvim-tree.lua" = nvim-tree-lua;
          "nvim_plugin-uga-rosa/ccc.nvim" = ccc-nvim;
          "nvim_plugin-voldikss/vim-floaterm" = vim-floaterm;
          "nvim_plugin-lewis6991/gitsigns.nvim" = gitsigns-nvim;
          "nvim_plugin-sindrets/diffview.nvim" = diffview-nvim;
          "nvim_plugin-RRethy/vim-illuminate" = vim-illuminate;
          "nvim_plugin-lukas-reineke/indent-blankline.nvim" = indent-blankline-nvim;
          "nvim_plugin-lnc3l0t/glow.nvim" = glow-nvim;
          "nvim_plugin-Almo7aya/openingh.nvim" = openingh-nvim;
          "nvim_plugin-tpope/vim-surround" = vim-surround;
          "nvim_plugin-johmsalas/text-case.nvim" = text-case-nvim;
          "nvim_plugin-mbbill/undotree" = undotree;
          "nvim_plugin-tpope/vim-sleuth" = vim-sleuth;
          "nvim_plugin-mfussenegger/nvim-lint" = nvim-lint;
          "nvim_plugin-stevearc/conform.nvim" = conform-nvim;
          "nvim_plugin-neovim/nvim-lspconfig" = nvim-lspconfig;
          "nvim_plugin-hrsh7th/nvim-cmp" = nvim-cmp;
          "nvim_plugin-L3MON4D3/LuaSnip" = luasnip;
          "nvim_plugin-saadparwaiz1/cmp_luasnip" = cmp_luasnip;
          "nvim_plugin-hrsh7th/cmp-nvim-lsp" = cmp-nvim-lsp;
          "nvim_plugin-hrsh7th/cmp-path" = cmp-path;
          "nvim_plugin-hrsh7th/cmp-buffer" = cmp-buffer;
          "nvim_plugin-zbirenbaum/copilot-cmp" = copilot-cmp;
          "nvim_plugin-zbirenbaum/copilot.lua" = copilot-lua;
          "nvim_plugin-folke/neodev.nvim" = neodev-nvim;
          "nvim_plugin-mrcjkb/rustaceanvim" = rustaceanvim;
          "nvim_plugin-Saecki/crates.nvim" = crates-nvim;
          "nvim_plugin-lvimuser/lsp-inlayhints.nvim" = lsp-inlayhints-nvim;
          "nvim_plugin-rafamadriz/friendly-snippets" = friendly-snippets;
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
          # curl # http requests TODO 
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
