{ self, pkgs, ... }:
pkgs.mkShellNoCC {
  inherit (self.checks.${pkgs.system}.pre-commit-check) shellHook;
  buildinputs = self.checks.${pkgs.system}.pre-commit-check.enabledPackages;

  packages = with pkgs; [
    git
  ];
}
