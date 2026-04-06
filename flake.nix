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
    "nvim_plugin-nvim-treesitter/nvim-treesitter-context".url =
      "github:nvim-treesitter/nvim-treesitter-context";
    "nvim_plugin-nvim-treesitter/nvim-treesitter-context".flake = false;
    "nvim_plugin-MunifTanjim/nui.nvim".url = "github:MunifTanjim/nui.nvim";
    "nvim_plugin-MunifTanjim/nui.nvim".flake = false; # component library util (used by llm_vim_command)
    "nvim_plugin-rmagatti/auto-session".url = "github:rmagatti/auto-session";
    "nvim_plugin-rmagatti/auto-session".flake = false; # Restore sessions
    "nvim_plugin-chrisgrieser/nvim-early-retirement".url = "github:chrisgrieser/nvim-early-retirement";
    "nvim_plugin-chrisgrieser/nvim-early-retirement".flake = false; # Close buffers in background if unused
    "nvim_plugin-nvim-lualine/lualine.nvim".url = "github:nvim-lualine/lualine.nvim";
    "nvim_plugin-nvim-lualine/lualine.nvim".flake = false;
    "nvim_plugin-folke/which-key.nvim".url = "github:folke/which-key.nvim";
    "nvim_plugin-folke/which-key.nvim".flake = false;
    "nvim_plugin-folke/snacks.nvim".url = "github:folke/snacks.nvim";
    "nvim_plugin-folke/snacks.nvim".flake = false;
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
    "nvim_plugin-lnc3l0t/glow.nvim".url = "github:lnc3l0t/glow.nvim";
    "nvim_plugin-lnc3l0t/glow.nvim".flake = false;
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
    "nvim_plugin-folke/lazydev.nvim".url = "github:folke/lazydev.nvim";
    "nvim_plugin-folke/lazydev.nvim".flake = false;
    "nvim_plugin-folke/trouble.nvim".url = "github:folke/trouble.nvim";
    "nvim_plugin-folke/trouble.nvim".flake = false;
    "nvim_plugin-direnv/direnv.vim".url = "github:direnv/direnv.vim";
    "nvim_plugin-direnv/direnv.vim".flake = false;
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
            "nvim_plugin-saghen/blink.cmp" = blink-cmp; # nixpkgs build includes prebuilt Rust fuzzy matcher
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
            nixfmt
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
            prettierd
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
            (pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
              neovimRcContent = ''
                lua ${luaNixGlobal}
                luafile ${./.}/init.lua
                set runtimepath^=${builtins.concatStringsSep "," (builtins.attrValues pkgs.vimPlugins.nvim-treesitter.grammarPlugins)}
              '';
              withPython3 = false;
              wrapRc = true;
              wrapperArgs = [
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
            options."ringofstorms-nvim" = {
              includeAllRuntimeDependencies = lib.mkEnableOption "Include all runtime dependencies (LSPs, formatters, linters, tools) in the packaged Neovim PATH.";

              underPrefix = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = ''
                  When null (default), installs this neovim as `nvim` globally in system packages.
                  When set to a string prefix, does NOT install as `nvim` — instead creates
                  `<prefix>` and `<prefix><prefix>` wrapper scripts so another system neovim is left untouched.
                  For example, underPrefix = "n" creates:
                    `n`  — launches this neovim
                    `nn` — deletes the session then launches this neovim
                '';
              };
            };

            config =
              let
                nvimPackage =
                  if cfg.includeAllRuntimeDependencies then
                    self.packages.${pkgs.system}.neovim
                  else
                    self.packages.${pkgs.system}.neovimMinimal;
              in
              lib.mkMerge [
                # When underPrefix is null, install as nvim globally (current behavior)
                (lib.mkIf (cfg.underPrefix == null) {
                  environment.systemPackages = [ nvimPackage ];
                })

                # When underPrefix is set, create named wrapper scripts instead
                (lib.mkIf (cfg.underPrefix != null) (
                  let
                    prefix = cfg.underPrefix;
                    nvimBin = lib.getExe nvimPackage;
                    prefixPkg = pkgs.writeShellScriptBin prefix ''
                      exec ${nvimBin} "$@"
                    '';
                    prefixPrefixPkg = pkgs.writeShellScriptBin "${prefix}${prefix}" ''
                      ${nvimBin} --headless '+SessionDelete' +qa > /dev/null 2>&1
                      exec ${nvimBin} "$@"
                    '';
                  in
                  {
                    environment.systemPackages = [
                      prefixPkg
                      prefixPrefixPkg
                    ];
                  }
                ))
              ];
          };
      };
    };
}
