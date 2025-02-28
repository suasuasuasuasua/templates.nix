{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.pre-commit-hooks.url = "github:cachix/git-hooks.nix";
  inputs.treefmt-nix.url = "github:numtide/treefmt-nix";

  outputs =
    {
      self,
      nixpkgs,
      pre-commit-hooks,
      treefmt-nix,
      ...
    }@inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});

      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = forAllSystems (
        system: (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix) nixpkgs.legacyPackages.${system}
      );
    in
    {
      templates = {
        default = self.templates.trivial;

        trivial = {
          path = ./trivial;
          description = "trivial template which runs hello world";
          welcomeText = ''
            # Getting started
            - Run `nix run`
          '';
        };
        python = {
          path = ./python;
          description = "Python template, using poetry2nix";
          welcomeText = ''
            # Getting started
            - Run `nix develop`
            - Run `poetry run python -m sample_package`
          '';
        };
      };

      #  for `nix fmt`
      formatter = forAllSystems (
        system: (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper) nixpkgs.legacyPackages.${system}
      );

      devShells = forAllSystems (system: {
        default = pkgs.${system}.mkShellNoCC {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;

          packages = with pkgs.${system}; [
            typst
            typstyle
            # TODO: add any other packages you need!
          ];
        };
      });

      checks = forAllSystems (system: {
        # for `nix flake check`
        formatting = (
          (pkgs: treefmtEval.${pkgs.system}.config.build.check) nixpkgs.legacyPackages.${system}
        );
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
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
        };
      });
    };
}
