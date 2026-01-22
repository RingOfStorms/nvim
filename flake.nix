{
  description = "RingOfStorms's Neovim configuration using nix flake for portability";
  # Nixpkgs / NixOS version to use.
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    # Names should always be `nvim_plugin-[lazy plugin name]`
    "nvim_plugin-folke/lazy.nvim".url = "github:folke/lazy.nvim";
    "nvim_plugin-folke/lazy.nvim".flake = false; # plugin manager and loader for fast bootup
    "nvim_plugin-catppuccin/nvim".url = "github:catppuccin/nvim";
    "nvim_plugin-catppuccin/nvim".flake = false; # color scheme
    "nvim_plugin-nvim-tree/nvim-web-devicons".url = "github:nvim-tree/nvim-web-devicons";
    "nvim_plugin-nvim-tree/nvim-web-devicons".flake = false;

    "nvim_plugin-m4xshen/hardtime.nvim".url = "github:m4xshen/hardtime.nvim";
    "nvim_plugin-m4xshen/hardtime.nvim".flake = false;
    "nvim_plugin-declancm/cinnamon.nvim".flake = false;
    "nvim_plugin-declancm/cinnamon.nvim".url = "github:declancm/cinnamon.nvim";

    "nvim_plugin-nvim-treesitter/nvim-treesitter-context".url =
      "github:nvim-treesitter/nvim-treesitter-context";
    "nvim_plugin-nvim-treesitter/nvim-treesitter-context".flake = false;
    # "nvim_plugin-nvim-treesitter/nvim-treesitter" NOTE: using nix pkgs since it is packaged with all grammars
    "nvim_plugin-nvim-lua/plenary.nvim".url = "github:nvim-lua/plenary.nvim";
    "nvim_plugin-nvim-lua/plenary.nvim".flake = false; # utils used by many plugins
    "nvim_plugin-MunifTanjim/nui.nvim".url = "github:MunifTanjim/nui.nvim";
    "nvim_plugin-MunifTanjim/nui.nvim".flake = false; # component library util
    "nvim_plugin-rmagatti/auto-session".url = "github:rmagatti/auto-session";
    "nvim_plugin-rmagatti/auto-session".flake = false; # Restore sessions
    "nvim_plugin-chrisgrieser/nvim-early-retirement".url = "github:chrisgrieser/nvim-early-retirement";
    "nvim_plugin-chrisgrieser/nvim-early-retirement".flake = false; # Close buffers in background if unused
    "nvim_plugin-rcarriga/nvim-notify".url = "github:rcarriga/nvim-notify";
    "nvim_plugin-rcarriga/nvim-notify".flake = false;
    "nvim_plugin-nvim-lualine/lualine.nvim".url = "github:nvim-lualine/lualine.nvim";
    "nvim_plugin-nvim-lualine/lualine.nvim".flake = false;
    "nvim_plugin-folke/which-key.nvim".url = "github:folke/which-key.nvim";
    "nvim_plugin-folke/which-key.nvim".flake = false;
    "nvim_plugin-nvim-telescope/telescope.nvim".url = "github:nvim-telescope/telescope.nvim";
    "nvim_plugin-nvim-telescope/telescope.nvim".flake = false; # popup search menu
    "nvim_plugin-nvim-telescope/telescope-fzf-native.nvim".url =
      "github:nvim-telescope/telescope-fzf-native.nvim";
    "nvim_plugin-nvim-telescope/telescope-fzf-native.nvim".flake = false; # fzf integration for telescope
    "nvim_plugin-nvim-telescope/telescope-ui-select.nvim".url =
      "github:nvim-telescope/telescope-ui-select.nvim";
    "nvim_plugin-nvim-telescope/telescope-ui-select.nvim".flake = false; # telescope used for selections in ui
    "nvim_plugin-aznhe21/actions-preview.nvim".url = "github:aznhe21/actions-preview.nvim";
    "nvim_plugin-aznhe21/actions-preview.nvim".flake = false; # telescope used for code action diffs in ui
    "nvim_plugin-nvim-telescope/telescope-file-browser.nvim".url =
      "github:nvim-telescope/telescope-file-browser.nvim";
    "nvim_plugin-nvim-telescope/telescope-file-browser.nvim".flake = false; # telescope based file browser
    "nvim_plugin-nvim-tree/nvim-tree.lua".url = "github:nvim-tree/nvim-tree.lua";
    "nvim_plugin-nvim-tree/nvim-tree.lua".flake = false; # tree based file browser
    "nvim_plugin-JoosepAlviste/nvim-ts-context-commentstring".url =
      "github:JoosepAlviste/nvim-ts-context-commentstring";
    "nvim_plugin-JoosepAlviste/nvim-ts-context-commentstring".flake = false;
    "nvim_plugin-windwp/nvim-ts-autotag".url = "github:windwp/nvim-ts-autotag";
    "nvim_plugin-windwp/nvim-ts-autotag".flake = false;
    "nvim_plugin-uga-rosa/ccc.nvim".url = "github:uga-rosa/ccc.nvim";
    "nvim_plugin-uga-rosa/ccc.nvim".flake = false;
    "nvim_plugin-lewis6991/gitsigns.nvim".url = "github:lewis6991/gitsigns.nvim";
    "nvim_plugin-lewis6991/gitsigns.nvim".flake = false;
    "nvim_plugin-sindrets/diffview.nvim".url = "github:sindrets/diffview.nvim";
    "nvim_plugin-sindrets/diffview.nvim".flake = false;
    "nvim_plugin-RRethy/vim-illuminate".url = "github:RRethy/vim-illuminate";
    "nvim_plugin-RRethy/vim-illuminate".flake = false;
    "nvim_plugin-lukas-reineke/indent-blankline.nvim".url =
      "github:lukas-reineke/indent-blankline.nvim";
    "nvim_plugin-lukas-reineke/indent-blankline.nvim".flake = false;
    "nvim_plugin-lnc3l0t/glow.nvim".url = "github:lnc3l0t/glow.nvim";
    "nvim_plugin-lnc3l0t/glow.nvim".flake = false;
    "nvim_plugin-MeanderingProgrammer/render-markdown.nvim".url =
      "github:MeanderingProgrammer/render-markdown.nvim";
    "nvim_plugin-MeanderingProgrammer/render-markdown.nvim".flake = false;
    "nvim_plugin-Almo7aya/openingh.nvim".url = "github:Almo7aya/openingh.nvim";
    "nvim_plugin-Almo7aya/openingh.nvim".flake = false;
    # mini.nvim replaces vim-surround, Comment.nvim
    "nvim_plugin-echasnovski/mini.nvim".url = "github:echasnovski/mini.nvim";
    "nvim_plugin-echasnovski/mini.nvim".flake = false;
    "nvim_plugin-johmsalas/text-case.nvim".url = "github:johmsalas/text-case.nvim";
    "nvim_plugin-johmsalas/text-case.nvim".flake = false;
    "nvim_plugin-mbbill/undotree".url = "github:mbbill/undotree";
    "nvim_plugin-mbbill/undotree".flake = false;
    "nvim_plugin-tpope/vim-sleuth".url = "github:tpope/vim-sleuth";
    "nvim_plugin-tpope/vim-sleuth".flake = false;
    "nvim_plugin-mfussenegger/nvim-lint".url = "github:mfussenegger/nvim-lint";
    "nvim_plugin-mfussenegger/nvim-lint".flake = false;
    "nvim_plugin-stevearc/conform.nvim".url = "github:stevearc/conform.nvim";
    "nvim_plugin-stevearc/conform.nvim".flake = false;
    "nvim_plugin-j-hui/fidget.nvim".url = "github:j-hui/fidget.nvim";
    "nvim_plugin-j-hui/fidget.nvim".flake = false;
    "nvim_plugin-neovim/nvim-lspconfig".url = "github:neovim/nvim-lspconfig";
    "nvim_plugin-neovim/nvim-lspconfig".flake = false;
    "nvim_plugin-b0o/schemastore.nvim".url = "github:b0o/schemastore.nvim";
    "nvim_plugin-b0o/schemastore.nvim".flake = false;
    # Completion: nvim-cmp (blink.cmp had stability issues)
    "nvim_plugin-hrsh7th/nvim-cmp".url = "github:hrsh7th/nvim-cmp";
    "nvim_plugin-hrsh7th/nvim-cmp".flake = false;
    "nvim_plugin-saadparwaiz1/cmp_luasnip".url = "github:saadparwaiz1/cmp_luasnip";
    "nvim_plugin-saadparwaiz1/cmp_luasnip".flake = false;
    "nvim_plugin-hrsh7th/cmp-nvim-lsp".url = "github:hrsh7th/cmp-nvim-lsp";
    "nvim_plugin-hrsh7th/cmp-nvim-lsp".flake = false;
    "nvim_plugin-hrsh7th/cmp-path".url = "github:hrsh7th/cmp-path";
    "nvim_plugin-hrsh7th/cmp-path".flake = false;
    "nvim_plugin-hrsh7th/cmp-buffer".url = "github:hrsh7th/cmp-buffer";
    "nvim_plugin-hrsh7th/cmp-buffer".flake = false;
    "nvim_plugin-L3MON4D3/LuaSnip".url = "github:L3MON4D3/LuaSnip";
    "nvim_plugin-L3MON4D3/LuaSnip".flake = false;
    "nvim_plugin-stevearc/dressing.nvim".url = "github:stevearc/dressing.nvim";
    "nvim_plugin-stevearc/dressing.nvim".flake = false;
    # lazydev.nvim replaces neodev.nvim (which is archived)
    "nvim_plugin-folke/lazydev.nvim".url = "github:folke/lazydev.nvim";
    "nvim_plugin-folke/lazydev.nvim".flake = false;
    # trouble.nvim for better diagnostics UI
    "nvim_plugin-folke/trouble.nvim".url = "github:folke/trouble.nvim";
    "nvim_plugin-folke/trouble.nvim".flake = false;
    # direnv.vim for project environment integration
    "nvim_plugin-direnv/direnv.vim".url = "github:direnv/direnv.vim";
    "nvim_plugin-direnv/direnv.vim".flake = false;
    # llama.vim for local AI autocomplete
    "nvim_plugin-ggml-org/llama.vim".url = "github:ggml-org/llama.vim";
    "nvim_plugin-ggml-org/llama.vim".flake = false;
    "nvim_plugin-mrcjkb/rustaceanvim".url = "github:mrcjkb/rustaceanvim";
    "nvim_plugin-mrcjkb/rustaceanvim".flake = false;
    "nvim_plugin-Saecki/crates.nvim".url = "github:Saecki/crates.nvim";
    "nvim_plugin-Saecki/crates.nvim".flake = false;
    "nvim_plugin-rafamadriz/friendly-snippets".url = "github:rafamadriz/friendly-snippets";
    "nvim_plugin-rafamadriz/friendly-snippets".flake = false;
    "nvim_plugin-ron-rs/ron.vim".url = "github:ron-rs/ron.vim";
    "nvim_plugin-ron-rs/ron.vim".flake = false;
    # "nvim_plugin-nosduco/remote-sshfs.nvim".url = "github:nosduco/remote-sshfs.nvim";
    # "nvim_plugin-nosduco/remote-sshfs.nvim".flake = false;
  };
  outputs =
    {
      self,
      nixpkgs,
      rust-overlay,
      ...
    }@inputs:
    let
      # Anytime there is a huge breaking change that old state files wont
      # work then we make a new version name. Helps separate any files and
      # "version" my neovim flake. Use this name for custom .config location
      # ==================
      version = "helium";
      # ===================

      # Utilities
      inherit (nixpkgs) lib;
      # Define the systems to support (all Linux systems exposed by nixpkgs)
      systems = lib.unique (
        lib.concatLists [
          lib.systems.flakeExposed
          lib.platforms.linux
        ]
      );
      forAllSystems = lib.genAttrs systems;
      # Create a mapping from system to corresponding nixpkgs : https://nixos.wiki/wiki/Overlays#In_a_Nix_flake
      nixpkgsFor = forAllSystems (system: (nixpkgs.legacyPackages.${system}.extend rustOverlay));

      # =========
      rustOverlay = import rust-overlay;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
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
                  nodejs_24_path = "${pkgs.nodejs_24}";
                  # This will look at all inputs and grab any prefixed with `nvim_plugin-`
                  pluginPaths =
                    builtins.foldl' (dirs: name: { "${name}" = inputs.${name}.outPath; } // dirs) nixPkgsPlugins
                      (builtins.filter (n: builtins.substring 0 12 n == "nvim_plugin-") (builtins.attrNames inputs));
                });
          # Core tools to prefer in PATH (prefix)
          runtimeDependenciesCore = with pkgs; [
            ripgrep
            fd
            tree-sitter
            fzf
            glow
            curl
            sshfs
            direnv # Auto-load project devShell environments

            # nix lang stuff
            nixfmt-rfc-style
            nil # nix
          ];

          # Full optional tools (suffix) — linters, formatters, LSPs
          runtimeDependenciesFull = with pkgs; [
            # linters
            markdownlint-cli
            biome
            svelte-check
            # formatters
            stylua
            nodePackages.prettier
            rustywind
            markdownlint-cli2
            sql-formatter
            libsForQt5.qt5.qtdeclarative # qmlformat
            # LSPs
            lua-language-server
            vscode-langservers-extracted # HTML/CSS/JSON/ESLint
            typescript-language-server
            svelte-language-server
            tailwindcss-language-server
            eslint_d
            python312Packages.python-lsp-server
            rust-analyzer
            marksman # markdown
            taplo # toml
            yaml-language-server
            lemminx # xml
            gopls # go
            # Other
            typescript
            nodejs_24
            clang
            (pkgs.rust-bin.stable.latest.default.override {
              extensions = [
                "rust-src"
                "rust-analyzer"
              ];
            })
          ];

          createNeovim =
            { full }:
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
                generatedWrapperArgs =
                  old.generatedWrapperArgs or [ ]
                  ++ [
                    # Add core tools, but let local devShell override
                    "--suffix"
                    "PATH"
                    ":"
                    "${lib.makeBinPath runtimeDependenciesCore}"
                  ]
                  ++ lib.optionals full [
                    # Add full toolchain, but let local devShell tools override
                    "--suffix"
                    "PATH"
                    ":"
                    "${lib.makeBinPath runtimeDependenciesFull}"
                  ]
                  ++ [
                    # Set the LAZY env path to the nix store, see init.lua for how it is used
                    "--set"
                    "LAZY"
                    "${lazyPath}"
                  ]
                  ++ [
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
                    # Fix wayland copy paste from system clipboard which uses XDG_RUNTIME_DIR so we need to symlink that into this
                    "--run"
                    ''[ ! -d "$XDG_RUNTIME_DIR" ] && mkdir -p "$XDG_RUNTIME_DIR"''
                    "--run"
                    ''
                      if [ -n "$WAYLAND_DISPLAY" ]; then
                          if [ ! -S "$XDG_RUNTIME_DIR/wayland-0" ]; then
                            mkdir -p "$XDG_RUNTIME_DIR"
                            ln -sf /run/user/$(id -u)/wayland-0 "$XDG_RUNTIME_DIR/wayland-0"
                          fi
                          if [ ! -S "$XDG_RUNTIME_DIR/wayland-1" ]; then
                            mkdir -p "$XDG_RUNTIME_DIR"
                            ln -sf /run/user/$(id -u)/wayland-1 "$XDG_RUNTIME_DIR/wayland-1"
                          fi
                        fi
                    ''
                  ]
                  ++ [
                    # Clear proxy environment variables
                    "--unset"
                    "http_proxy"
                    "--unset"
                    "https_proxy"
                    "--unset"
                    "ftp_proxy"
                    "--unset"
                    "all_proxy"
                    "--unset"
                    "HTTP_PROXY"
                    "--unset"
                    "HTTPS_PROXY"
                    "--unset"
                    "FTP_PROXY"
                    "--unset"
                    "ALL_PROXY"
                  ];
              });
        in
        {
          default = self.packages.${system}.neovim;
          neovim = createNeovim { full = true; };
          neovimMinimal = createNeovim { full = false; };
        }
      );
      nixosModules = {
        default =
          {
            pkgs,
            lib,
            config,
            ...
          }:
          let
            cfg = config."ringofstorms-nvim";
          in
          {
            options."ringofstorms-nvim".includeAllRuntimeDependencies =
              lib.mkEnableOption "Include all runtime dependencies (LSPs, formatters, linters, tools) in the packaged Neovim PATH.";

            config = {
              environment.systemPackages = [
                (
                  if cfg.includeAllRuntimeDependencies then
                    self.packages.${pkgs.system}.neovim
                  else
                    self.packages.${pkgs.system}.neovimMinimal
                )
              ];
            };
          };
      };
    };
}
