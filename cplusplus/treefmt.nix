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

    # cpp
    clang-format.enable = true;
    cmake-format.enable = true;

    # typst
    typstyle.enable = true;

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
