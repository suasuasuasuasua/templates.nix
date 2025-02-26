# treefmt.nix
{ pkgs, ... }:
{
  # Used to find the project root
  projectRootFile = "flake.nix";
  settings = {
    on-unmatched = "debug";
  };

  programs = {
    # nix
    nixfmt.enable = pkgs.lib.meta.availableOn pkgs.stdenv.buildPlatform pkgs.nixfmt-rfc-style.compiler;
    nixfmt.package = pkgs.nixfmt-rfc-style;

    # json
    jsonfmt.enable = true;

    # yaml
    yamlfmt.enable = true;

    # toml
    taplo.enable = true;

    # markdown
    mdformat.enable = true;
  };
}
