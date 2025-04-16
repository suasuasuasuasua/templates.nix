{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    git-hooks.url = "github:cachix/git-hooks.nix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      git-hooks,
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
      pkgsFor = forAllSystems (system: nixpkgs.legacyPackages.${system});

      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = forAllSystems (system: (treefmt-nix.lib.evalModule pkgsFor.${system} ./treefmt.nix));
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
      formatter = forAllSystems (system: treefmtEval.${pkgsFor.${system}.system}.config.build.wrapper);

      devShells = forAllSystems (system: {
        default = import ./shell.nix {
          inherit self;
          pkgs = pkgsFor.${system};
        };
      });

      checks = forAllSystems (system: {
        # for `nix flake check`
        formatting = treefmtEval.${pkgsFor.${system}}.config.build.check;
        pre-commit-check = git-hooks.lib.${system}.run {
          src = ./.;
          imports = [ ./git-hooks.nix ];
        };
      });
    };
}
