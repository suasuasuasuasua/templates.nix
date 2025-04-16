{ self, pkgs, ... }:
let
  inherit (pkgs) system;
in
pkgs.mkShellNoCC {
  inherit (self.checks.${system}.pre-commit-check) shellHook;
  buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;

  packages = with pkgs.${system}; [
    typst
    typstyle
  ];
}
