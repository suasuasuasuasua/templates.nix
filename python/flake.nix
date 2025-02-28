{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.poetry2nix.url = "github:nix-community/poetry2nix";
  inputs.pre-commit-hooks.url = "github:cachix/git-hooks.nix";
  inputs.treefmt-nix.url = "github:numtide/treefmt-nix";

  outputs =
    {
      self,
      nixpkgs,
      poetry2nix,
      pre-commit-hooks,
      treefmt-nix,
      ...
    }:
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
      packages = forAllSystems (
        system:
        let
          inherit (poetry2nix.lib.mkPoetry2Nix { pkgs = pkgs.${system}; }) mkPoetryApplication;
        in
        {
          default = mkPoetryApplication {
            projectDir = self;
            # TODO: change python3 version here!
            python = pkgs.python313;
          };
        }
      );

      #  for `nix fmt`
      formatter = forAllSystems (
        system: (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper) nixpkgs.legacyPackages.${system}
      );

      devShells = forAllSystems (
        system:
        let
          inherit (poetry2nix.lib.mkPoetry2Nix { pkgs = pkgs.${system}; }) mkPoetryEnv;
        in
        {
          default = pkgs.${system}.mkShellNoCC {
            packages = with pkgs.${system}; [
              (mkPoetryEnv {
                projectDir = self;
                # TODO: change python3 version here!
                python = python313;
              })
              poetry
            ];

            inherit (self.checks.${system}.pre-commit-check) shellHook;
            buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
          };
        }
      );

      checks = forAllSystems (system: {
        # for `nix flake check`
        formatting = (
          (pkgs: treefmtEval.${pkgs.system}.config.build.check) nixpkgs.legacyPackages.${system}
        );
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
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
