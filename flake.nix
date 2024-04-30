{
  description = "RingOfStorms's Neovim configuration using nix flake for portability";
  # Nixpkgs / NixOS version to use.
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";


    "nvim_plugin-folke/lazy.nvim" = {
      url = "github:folke/lazy.nvim";
      flake = false;
    };
    "nvim_plugin-catppuccin/nvim" = {
      url = "github:catppuccin/nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... } @ inputs:
    # Takes all top level attributes and changes them to `attribute.${system} = old value`
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = nixpkgs.lib;

        # This will look at all inputs and grab any prefixed with `nvim_plugin-`
        nvimPluginPaths = "NVIM_PLUGIN_PATHS=" + lib.generators.toLua
          {
            multiline = false;
            indent = false;
          }
          (
            builtins.foldl'
              (dirs: name:
                {
                  "${name}" = inputs.${name}.outPath;
                } // dirs)
              { }
              (builtins.filter
                (n: builtins.substring 0 12 n == "nvim_plugin-")
                (builtins.attrNames inputs))
          )
        ;
        nvimConfigStorePath = ''NVIM_CONFIG_STORE_PATH="${./.}"'';

        runtimeDependencies = with pkgs; [
          ripgrep
          curl
          cowsay
          nodePackages.cspell
        ];

        treesitterParsers = builtins.attrValues pkgs.vimPlugins.nvim-treesitter.grammarPlugins;

        # https://zimbatm.com/notes/1000-instances-of-nixpkgs
        # Read article for why we don't do the below version
        # pkgs = import nixpkgs {
        #   inherit system;
        # };

        # TODO
        # cpsell = pkgs.nodePackages.cpsell;

        # source = nixpkgs.lib.cleanSourceWith {
        #   src = self;
        #   filter = name: type:
        #     let
        #       base = baseNameOf name;
        #     in
        #     nixpkgs.lib.cleanSourceFilter
        #       name
        #       type && (base != ".git") && (base != "flake.nix") && (base != "flake.lock");
        # };
      in
      {
        packages = {
          default = self.packages.${system}.neovim;
          neovim =
            (pkgs.wrapNeovimUnstable
              pkgs.neovim-unwrapped
              (pkgs.neovimUtils.makeNeovimConfig
                {
                  withPython3 = false;
                  customRC = ''
                    lua ${nvimPluginPaths}
                    lua ${nvimConfigStorePath}
                    luafile ${./.}/init.lua
                    set runtimepath^=${builtins.concatStringsSep "," treesitterParsers}
                  '';
                  # lua package.path = package.path .. ";${./.}/lua/?.lua"
                  #   lua print("HELLO WORLD 123! TEST")
                  #   lua print("${./.}")
                  # -- lua package.runtimepath = "${./.}`
                  # plugins = [
                  #   pkgs.vimPlugins.nvim-treesitter.withAllGrammars
                  # ];
                  # customRC = import ./lua { inherit lib self; };
                  # wrapperArgs = [
                  #   # Add runtime dependencies to neovim path
                  #   "--prefix"
                  #   "PATH"
                  #   ":"
                  #   "${lib.makeBinPath runtimeDependencies}"
                  #   # Set the LAZY env path to the nix store
                  #   "--set"
                  #   "LAZY"
                  #   "${inputs.nvim_plugin-folke/lazy.nvim}"
                  #   # Use custom XDG_CONFIG_HOME so it doesn't use the user's real one
                  #   # TODO do I need to set all the XDG_ env vars? - or should I remove this entirely?
                  #   "--set"
                  #   "XDG_CONFIG_HOME"
                  #   "${./.}"
                  # ];
                }

              )
            ).overrideAttrs
              (old: {
                generatedWrapperArgs = old.generatedWrapperArgs or [ ] ++ [
                  # Add runtime dependencies to neovim path
                  "--prefix"
                  "PATH"
                  ":"
                  "${lib.makeBinPath runtimeDependencies}"
                  # Set the LAZY env path to the nix store
                  "--set"
                  "LAZY"
                  "${inputs."nvim_plugin-folke/lazy.nvim"}"
                  # Use custom XDG_CONFIG_HOME so it doesn't use the user's real one
                  # TODO do I need to set all the XDG_ env vars? - or should I remove this entirely?
                  "--set"
                  "XDG_CONFIG_HOME"
                  "~/.config/nvim_flaked"
                  "--set"
                  "XDG_DATA_HOME"
                  "~/.local/share/nvim_flaked"
                  "--set"
                  "XDG_RUNTIME_DIR"
                  "/tmp/nvim.user/nvim_flaked/xxx"
                  "--set"
                  "XDG_STATE_HOME"
                  "~/.local/state/nvim_flaked"
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


