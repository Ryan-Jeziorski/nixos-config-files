{
  inputs = {
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    flake-utils.follows = "nix-vscode-extensions/flake-utils";
    nixpkgs.follows = "nix-vscode-extensions/nixpkgs";
  };

  outputs =
    inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        extensions = inputs.nix-vscode-extensions.extensions.${system};
        inherit (pkgs) vscode-with-extensions vscodium;

        packages.default = vscode-with-extensions.override {
          vscode = vscodium;
          vscodeExtensions = [
            extensions.vscode-marketplace.golang.go

            extensions.vscode-marketplace.bbenoist.nix
            extensions.vscode-marketplace.rust-lang.rust-analyzer
            extensions.vscode-marketplace.vscodevim.vim
            extensions.vscode-marketplace.karunamurti.tera
            extensions.vscode-marketplace.samuelcolvin.jinjahtml
            extensions.open-vsx.jeanp413.open-remote-ssh
          ];
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [ packages.default ];
          shellHook = ''
            printf "VSCodium with extensions:\n"
            codium --list-extensions
          '';
        };
      in
      {
        inherit packages devShells;
      }
    );
}
