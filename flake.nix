{
  description = "programming from the bottom up";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-22.05;
    flake-utils = {
      url = github:numtide/flake-utils;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    let
      defaultSystems = [
        "i686-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    in
    flake-utils.lib.eachSystem defaultSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      rec {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.gcc
            pkgs.gef
            pkgs.pwntools
            pkgs.radare2
            #pkgs.nasm
          ];
        };

        packages = flake-utils.lib.flattenTree {
          maximum = pkgs.stdenv.mkDerivation {
            src = ./maximum;
            name = "maximum";
            installPhase = ''
              mkdir -p $out/bin
              cp maximum $out/bin/maximum
            '';
          };
        };

        defaultPackage = packages.maximum;
      });
}
