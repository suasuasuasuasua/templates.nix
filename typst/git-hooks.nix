{
  hooks = {
    # Nix
    nixfmt-rfc-style.enable = true;
    deadnix.enable = true;

    # Git
    commitizen.enable = true;

    # Docs
    markdownlint.enable = true;
    typstyle.enable = true;

    # General
    check-merge-conflicts.enable = true;
    end-of-file-fixer.enable = true;
    trim-trailing-whitespace.enable = true;
  };
}
