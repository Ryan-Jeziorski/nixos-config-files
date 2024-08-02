{
  description = "NixOS configuration";

  inputs = {
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    flake-utils.follows = "nix-vscode-extensions/flake-utils";
    nixpkgs.follows = "nix-vscode-extensions/nixpkgs";
  };

  outputs = inputs @ {
    self, 
    nixpkgs,
    flake-utils,
    nix-vscode-extensions,
    ...
  }: 
  let inherit (self) outputs;
  in {
    nixosConfigurations.latitude-nix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs outputs;};
      modules = [ 
        ./hosts/latitude-nix/configuration.nix 
        ./hosts/latitude-nix/hardware-configuration.nix
        ./programs/vscodium.nix
        { 
          # Networking
          networking.hostName = "latitude-nix"; 

          # Bootloader.
          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;
        }
      ];
    };

/*
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

    nixosConfigurations.roshar = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs outputs;};
      modules = [ 
        ./hosts/roshar/configuration.nix 
        ./hosts/roshar/hardware-configuration.nix
        { 
          # Networking
          networking.hostName = "roshar"; 

          # Bootloader.
          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;
        }
      ];
    };
*/
  };
}
