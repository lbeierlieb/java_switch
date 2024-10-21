{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nix-community/naersk";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs22.url = "github:NixOS/nixpkgs/05bbf675397d5366259409139039af8077d695ce";
    nixpkgs21.url = "github:NixOS/nixpkgs/05bbf675397d5366259409139039af8077d695ce";
    nixpkgs20.url = "github:NixOS/nixpkgs/05bbf675397d5366259409139039af8077d695ce";
    nixpkgs19.url = "github:NixOS/nixpkgs/05bbf675397d5366259409139039af8077d695ce";
    nixpkgs18.url = "github:NixOS/nixpkgs/b3a285628a6928f62cdf4d09f4e656f7ecbbcafb";
    nixpkgs17.url = "github:NixOS/nixpkgs/05bbf675397d5366259409139039af8077d695ce";
    nixpkgs16.url = "github:NixOS/nixpkgs/407f8825b321617a38b86a4d9be11fd76d513da2";
    nixpkgs15.url = "github:NixOS/nixpkgs/0ffaecb6f04404db2c739beb167a5942993cfd87";
  };

  outputs = { self, flake-utils, naersk, nixpkgs, nixpkgs22, nixpkgs21, nixpkgs20, nixpkgs19, nixpkgs18, nixpkgs17, nixpkgs16, nixpkgs15 }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs) {
          inherit system;
        };
        pkgs22 = (import nixpkgs22) {
          inherit system;
        };
        pkgs21 = (import nixpkgs21) {
          inherit system;
        };
        pkgs20 = (import nixpkgs20) {
          inherit system;
        };
        pkgs19 = (import nixpkgs19) {
          inherit system;
        };
        pkgs18 = (import nixpkgs18) {
          inherit system;
        };
        pkgs17 = (import nixpkgs17) {
          inherit system;
        };
        pkgs16 = (import nixpkgs16) {
          inherit system;
        };
        pkgs15 = (import nixpkgs15) {
          inherit system;
        };

        naersk' = pkgs.callPackage naersk {};

      in rec {
        # For `nix build` & `nix run`:
        defaultPackage = naersk'.buildPackage {
          src = ./.;
          buildInputs = [
            pkgs15.openjdk15_headless
            pkgs16.openjdk16_headless
            pkgs17.openjdk17_headless
            pkgs18.openjdk18_headless
            pkgs19.openjdk19_headless
            pkgs20.openjdk20_headless
            pkgs21.openjdk21_headless
            pkgs22.openjdk22_headless
          ];
          postInstall = ''
            ln -s ${pkgs15.openjdk15_headless}/bin/javac $out/bin/javac15
            ln -s ${pkgs16.openjdk16_headless}/bin/javac $out/bin/javac16
            ln -s ${pkgs17.openjdk17_headless}/bin/javac $out/bin/javac17
            ln -s ${pkgs18.openjdk18_headless}/bin/javac $out/bin/javac18
            ln -s ${pkgs19.openjdk19_headless}/bin/javac $out/bin/javac19
            ln -s ${pkgs20.openjdk20_headless}/bin/javac $out/bin/javac20
            ln -s ${pkgs21.openjdk21_headless}/bin/javac $out/bin/javac21
            ln -s ${pkgs22.openjdk22_headless}/bin/javac $out/bin/javac22
          '';
        };

        # For `nix develop`:
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [ rustc cargo ];
        };
      }
    );
}
