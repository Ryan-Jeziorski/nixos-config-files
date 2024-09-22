{
  description = "NixOS configuration";

  inputs = {
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    flake-utils.follows = "nix-vscode-extensions/flake-utils";
    nixpkgs.follows = "nix-vscode-extensions/nixpkgs";
    nixvim.url = "github:Ryan-Jeziorski/nix-vim-config/dev";
  };

  outputs = inputs @ {
    self, 
    nixpkgs,
    flake-utils,
    nix-vscode-extensions,
    nixvim,
    ...
  }: 
  flake-parts.lib.mkFlake { inherit inputs; } {

    nixosConfigurations.braize = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = {inherit inputs outputs pkgs ;};
      specialArgs.user = "ryan";
      modules = [ 
        ./hosts/braize/configuration.nix 
        ./hosts/braize/hardware-configuration.nix
        {
          # Networking
          #networking.hostName = "ashyn"; 

          # Bootloader.
          #boot.loader.systemd-boot.enable = true;
          #boot.loader.efi.canTouchEfiVariables = true;
        }
      ];
    };
  };
}
