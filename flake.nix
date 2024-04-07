{
  description = "RingOfStorms's Neovim configuration using nix flake for portability";
  # Nixpkgs / NixOS version to use.
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # inputs.nixpkgs.follows = "nixpkgs";


    # All my neovim plguins managed by flake. Lazy will only be used for loading/configuration with direct dir links to these.
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

        runtimeDependencies = with pkgs; [
          cowsay
        ];
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
          neovim = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (
            pkgs.neovimUtils.makeNeovimConfig
              {
                customRC = ''
                  lua print("HELLO WORLD 123! TEST")
                  lua ${nvimPluginPaths}
                  lua package.path =";${./.}/lua/?.lua" .. package.path
                  luafile ${./.}/init.lua
                '';
                # set runtimepath^=${builtins.concatStringsSep "," treesitterParsers}
              }
            // {
              wrapperArgs = [
                # Add runtime dependencies to neovim path
                "--prefix"
                "PATH"
                ":"
                "${lib.makeBinPath runtimeDependencies}"
                # Use custom XDG_CONFIG_HOME so it doesn't use the user's real one
                "--set"
                "XDG_CONFIG_HOME"
                "~/.config/ringofstorms_neovim"
              ];
            }
          );
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


