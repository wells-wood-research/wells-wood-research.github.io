{
  description = "Wells Wood Research Group website";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.elmPackages.elm
            pkgs.nodejs_20
          ];

          shellHook = ''
            export ELM_HOME="$PWD/.elm"
            export PATH="$PWD/node_modules/.bin:$PATH"
          '';
        };
      }
    );
}
