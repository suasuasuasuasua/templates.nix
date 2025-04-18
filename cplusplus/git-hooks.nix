{
  hooks = {
    # Nix
    nixfmt-rfc-style.enable = true;
    deadnix.enable = true;

    # Git
    commitizen.enable = true;

    # cpp
    clang-format.enable = true;
    # cmake-format.enable = true; # NOTE: style is weird...

    # Docs
    markdownlint.enable = true;
    typstyle.enable = true;

    # General
    check-merge-conflicts.enable = true;
    end-of-file-fixer.enable = true;
    trim-trailing-whitespace.enable = true;
  };
}
