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
        python = {
          path = "./python";
          description = "Python template, using poetry2nix";
          welcomeText = ''
            # Getting started
            - Run `nix develop`
            - Run `poetry run python -m sample_package`
          '';
        };
        trivial = {
          path = "./trivial";
          description = "trivial template which runs hello world";
          welcomeText = ''
            # Getting started
            - Run `nix run`
          '';
        };
      };

      defaultTemplate = self.templates.trivial;

      #  for `nix fmt`
      formatter = forAllSystems (
        system: (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper) nixpkgs.legacyPackages.${system}
      );

      devShells = forAllSystems (system: {
        default = pkgs.${system}.mkShellNoCC {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
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

            # Python
            poetry-check.enable = true;
            black.enable = true;
            isort = {
              enable = true;
              settings.profile = "black";
            };
            autoflake.enable = true;
          };
        };
      });
    };
}
