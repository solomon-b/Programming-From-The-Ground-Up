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
            pkgs.gef
            pkgs.nasm
            pkgs.pwntools
            pkgs.radare2
          ];
        };

        packages = flake-utils.lib.flattenTree {
          exit = pkgs.stdenv.mkDerivation {
            src = ./exit;
            name = "exit";
            buildInputs = [ pkgs.nasm ];
            installPhase = ''
              mkdir -p $out/bin
              cp exit $out/bin/exit
            '';
          };

          maximum = pkgs.stdenv.mkDerivation {
            src = ./maximum;
            name = "maximum";
            buildInputs = [ pkgs.nasm ];
            installPhase = ''
              mkdir -p $out/bin
              cp maximum $out/bin/maximum
            '';
          };

          power = pkgs.stdenv.mkDerivation {
            src = ./power;
            name = "power";
            buildInputs = [ pkgs.nasm ];
            installPhase = ''
              mkdir -p $out/bin
              cp power $out/bin/power
            '';
          };
        };

        defaultPackage = packages.maximum;
      });
}
