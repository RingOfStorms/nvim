{
  description = "RingOfStorms's Neovim configuration using nix flake for portability";
  # Nixpkgs / NixOS version to use.
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    {
      # TODO any non each system attributes here
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        # TODO
        # cpsell = pkgs.nodePackages.cpsell;

        source = nixpkgs.lib.cleanSourceWith {
          src = self;
          filter = name: type:
            let
              base = baseNameOf name;
            in
            nixpkgs.lib.cleanSourceFilter
              name
              type && (base != ".git") && (base != "flake.nix") && (base != "flake.lock");
        };
      in
      {
        # defaultPackage = pkgs.neovim;
        defaultPackage = pkgs.stdenv.mkDerivation {
          name = "nvim";
          nativeBuildInputs = with pkgs; [ makeWrapper rsync ];
          buildInputs = with pkgs; [ neovim ];

          unpackPhase = ":";
          installPhase = ''
              mkdir -p $out/bin
              cp ${pkgs.neovim}/bin/nvim $out/bin/nvim
              wrapProgram $out/bin/nvim --run "
                export XDG_CONFIG_HOME=$out/config

              "
              mkdir -p $out/share/nvim
              rsync -a ${source}/ $out/share/nvim
          '';
          # ln -s ${cpsell}/bin/cpsell $out/bin/cpsell
        };
      });

}


