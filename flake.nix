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
  };

  outputs = { self, flake-utils, naersk, nixpkgs, nixpkgs22, nixpkgs21, nixpkgs20, nixpkgs19, nixpkgs18, nixpkgs17 }:
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

        naersk' = pkgs.callPackage naersk {};

      in rec {
        # For `nix build` & `nix run`:
        defaultPackage = naersk'.buildPackage {
          src = ./.;
          buildInputs = [
            pkgs17.openjdk17
            pkgs18.openjdk18
            pkgs19.openjdk19
            pkgs20.openjdk20
            pkgs21.openjdk21
            pkgs22.openjdk22
          ];
          postInstall = ''
            ln -s ${pkgs17.openjdk17}/bin/javac $out/bin/javac17
            ln -s ${pkgs18.openjdk18}/bin/javac $out/bin/javac18
            ln -s ${pkgs19.openjdk19}/bin/javac $out/bin/javac19
            ln -s ${pkgs20.openjdk20}/bin/javac $out/bin/javac20
            ln -s ${pkgs21.openjdk21}/bin/javac $out/bin/javac21
            ln -s ${pkgs22.openjdk22}/bin/javac $out/bin/javac22
          '';
        };

        # For `nix develop`:
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [ rustc cargo ];
        };
      }
    );
}
