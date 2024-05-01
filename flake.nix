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
# TODO TELESCOPE
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

        # This will be how we put any nix related stuff into our lua config
        luaNixGlobal = "NIX=" + lib.generators.toLua { multiline = false; indent = false; } ({
          storePath = "${./.}";
          # This will look at all inputs and grab any prefixed with `nvim_plugin-`
          pluginPaths = builtins.foldl'
            (dirs: name:
              {
                "${name}" = inputs.${name}.outPath;
              } // dirs)
            { }
            (builtins.filter
              (n: builtins.substring 0 12 n == "nvim_plugin-")
              (builtins.attrNames inputs));
        });

        runtimeDependencies = with pkgs; [
          ripgrep # search
          fd # search
          fzf # search fuzzy
          curl # http requests
          glow # markdown renderer
          nodePackages.cspell
        ] ++ builtins.attrValues pkgs.vimPlugins.nvim-treesitter.grammarPlugins;

        # treesitterParsers = builtins.attrValues pkgs.vimPlugins.nvim-treesitter.grammarPlugins;
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
                '';
                # set runtimepath^=${builtins.concatStringsSep "," treesitterParsers}
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
              })

          ;
          # neovim = pkgs.stdenv.mkDerivation {
          #   name = "nvim";
          #   nativeBuildInputs = with pkgs; [ makeWrapper rsync ];
          #   buildInputs = with pkgs; [ neovim cowsay ];

          #   unpackPhase = ":";
          #   installPhase = ''
          #     mkdir -p $out/bin
          #     cp ${pkgs.neovim}/bin/nvim $out/bin/nvim
          #     wrapProgram $out/bin/nvim --run "
          #       export XDG_CONFIG_HOME=$out/config
          #     "
          #     mkdir -p $out/share/nvim
          #     rsync -a ${source}/ $out/share/nvim
          #     ln -s ${pkgs.cowsay}/bin/cowsay $out/bin/cowsay
          #   '';
          #   # ln -s ${cpsell}/bin/cpsell $out/bin/cpsell
          # };
        };
      });

}


