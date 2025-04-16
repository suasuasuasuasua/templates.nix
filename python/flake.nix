{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    poetry2nix.url = "github:nix-community/poetry2nix";
    git-hooks.url = "github:cachix/git-hooks.nix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      poetry2nix,
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
      pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});

      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = forAllSystems (system: treefmt-nix.lib.evalModule pkgs.${system} ./treefmt.nix);
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
            python = pkgs.python313;
          };
        }
      );

      #  for `nix fmt`
      formatter = forAllSystems (system: treefmtEval.${pkgs.${system}.system}.config.build.wrapper);

      devShells = forAllSystems (system: {
        default = import ./shell.nix {
          inherit self;
          inherit (poetry2nix.lib.mkPoetry2Nix { pkgs = pkgs.${system}; }) mkPoetryEnv;
          pkgs = pkgs.${system};
        };
      });

      checks = forAllSystems (system: {
        # for `nix flake check`
        formatting = treefmtEval.${pkgs.${system}}.config.build.check self;
        pre-commit-check = git-hooks.lib.${system}.run {
          src = ./.;
          imports = [ ./git-hooks.nix ];
        };
      });
    };
}
