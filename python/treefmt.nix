# treefmt.nix
{ pkgs, ... }:
{
  # Used to find the project root
  projectRootFile = "flake.nix";

  programs = {
    # nix
    nixfmt.enable = pkgs.lib.meta.availableOn pkgs.stdenv.buildPlatform pkgs.nixfmt-rfc-style.compiler;
    nixfmt.package = pkgs.nixfmt-rfc-style;

    # python
    black.enable = true;

    # json
    jsonfmt.enable = true;

    # yaml
    yamlfmt.enable = true;

    # toml
    taplo.enable = true;

    # markdown
    mdformat.enable = true;

    # just
    just.enable = true;
  };
  # ignore certain files
  settings.global.excludes = [
    "*.png"
    ".pre-commit-config.yaml"
    ".envrc"
    ".direnv/*"
    ".devenv/*"
  ];
}
