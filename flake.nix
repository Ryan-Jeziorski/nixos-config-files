{
  description = "NixOS configuration";

  inputs = {
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    flake-utils.follows = "nix-vscode-extensions/flake-utils";
    nixpkgs.follows = "nix-vscode-extensions/nixpkgs";
    nixvim.url = "github:Ryan-Jeziorski/nix-vim-config/dev";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    self, 
    ...
  }: 
  inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" "aarch64-linux" ];

    flake = {
      nixosConfigurations.braize = inputs.nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {inherit inputs ;};
        specialArgs.user = "ryan";
        modules = [ 
          ./hosts/braize/configuration.nix 
          ./hosts/braize/hardware-configuration.nix
          {
            environment.systemPackages = [
              inputs.nixvim.legacyPackages.aarch64-linux.nixvim
            ];
          }
        ];
      };
    };
  };
}
