{
  description = "NixOS configuration";

  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nixpkgs.follows = "nix-vscode-extensions/nixpkgs";
  };

  outputs = inputs @ {
    self, 
    nixpkgs, 
    nix-vscode-extensions,
    ...
  }: 
  let inherit (self) outputs;
  in {
    overlays = import ./overlays {inherit inputs;};
    nixpkgs = {
      overlays = [
        outputs.overlays.vscode-extensions
      ];
    };

    nixosConfigurations.latitude-nix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs outputs;};
      modules = [ 
        ./configuration.nix 
        ./hardware-configurations/latitude-nix/hardware-configuration.nix
        { networking.hostName = "latitude-nix"; }
      ];
    };

    nixosConfigurations.lumbridge = nixpkgs.lib.nixosSystem {
      system = "x86-64-linux";
      specialArgs = {inherit inputs outputs;};
      modules = [
        ./hosts/lumbridge/configuration.nix
        ./hosts/lumbridge/hardware-configuration.nix
        { 
          networking.hostName = "lumbridge"; 
          # Bootloader.
          boot.loader.grub.enable = true;
          boot.loader.grub.device = "/dev/sda";
          boot.loader.grub.useOSProber = true;
        }
      ];
    };
  };
}
