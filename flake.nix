{
  description = "RingOfStorms's Neovim configuration using nix flake for portability";
  # Nixpkgs / NixOS version to use.
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # Names should always be `nvim_plugin-[lazy plugin name]`
    # Only need to add plugins as flake inputs if they are:
    # - Missing in nixpkgs
    # - We want to pin a specific version diverging from nixpkgs channel
    "nvim_plugin-chrisgrieser/nvim-early-retirement" = {
      url = "github:chrisgrieser/nvim-early-retirement";
      flake = false;
    };
    "nvim_plugin-declancm/cinnamon.nvim" = {
      url = "github:declancm/cinnamon.nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... } @ inputs:
    # Takes all top level attributes and changes them to `attribute.${system} = old value`
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = nixpkgs.lib;

        lazyPath = pkgs.vimPlugins.lazy-nvim; # inputs."nvim_plugin-folke/lazy.nvim"
        # Plugins provided in nixpkgs, match the naming scheme above for keys
        nixPkgsPlugins = with pkgs.vimPlugins; {
          "nvim_plugin-folke/lazy.nvim" = lazyPath;
          "nvim_plugin-nvim-treesitter/nvim-treesitter" = nvim-treesitter.withAllGrammars;
          "nvim_plugin-nvim-lua/plenary.nvim" = plenary-nvim;
          "nvim_plugin-catppuccin/nvim" = catppuccin-nvim;
          "nvim_plugin-Pocco81/auto-save.nvim" = auto-save-nvim;
          "nvim_plugin-MunifTanjim/nui.nvim" = nui-nvim;
          "nvim_plugin-rcarriga/nvim-notify" = nvim-notify;
          "nvim_plugin-folke/noice.nvim" = noice-nvim;
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
          "nvim_plugin-folke/neodev.nvim" = neodev-nvim;
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
            nixPkgsPlugins
            (builtins.filter
              (n: builtins.substring 0 12 n == "nvim_plugin-")
              (builtins.attrNames inputs));
        });

        runtimeDependencies = with pkgs; [
          # tools
          ripgrep # search
          fd # search
          fzf # search fuzzy
          tree-sitter
          glow # markdown renderer
          # linters
          markdownlint-cli
          luajitPackages.luacheck
          biome # (t|s)j[x]
          # formatters
          stylua
          nodePackages.prettier
          # LSPs
          lua-language-server
          nodePackages.typescript-language-server
          nodePackages.pyright

          # curl # http requests TODO 
          # nodePackages.cspell TODO
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
                  "${lazyPath}"
                  # Don't use default directories to not collide with another neovim config
                  # All things at runtime should be deletable since we are using nix to handle downloads and bins.
                  "--set"
                  "XDG_CONFIG_HOME"
                  "/tmp/nvim_flaked.USR_TODO/config" # TODO
                  "--set"
                  "XDG_DATA_HOME"
                  "/tmp/nvim_flaked.USR_TODO/share"
                  "--set"
                  "XDG_RUNTIME_DIR"
                  "/tmp/nvim_flaked.USR_TODO/run"
                  "--set"
                  "XDG_STATE_HOME"
                  "/tmp/nvim_flaked.USR_TODO/state"
                ];
              });
        };
      });
}

