{
  description = "NixOS configuration";

  inputs = {
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    flake-utils.follows = "nix-vscode-extensions/flake-utils";
    nixpkgs.follows = "nix-vscode-extensions/nixpkgs";
    nixvim = {
      url = "github:Ryan-Jeziorski/nix-vim-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self, 
    nixpkgs,
    flake-utils,
    nix-vscode-extensions,
    nixvim,
    ...
  }: 
  let 
    inherit (self) outputs;
    system = "x86_64-linux";
    extensions = inputs.nix-vscode-extensions.extensions.${system};
    inherit (pkgs) vscode-with-extensions vscodium nixvim;
    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true; };
    };
  in {

    nixosConfigurations.latitude-nix = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs system pkgs extensions vscode-with-extensions vscodium nixvim;};
      specialArgs.user = "ryan";
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

    nixosConfigurations.lumbridge = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs system pkgs extensions vscode-with-extensions vscodium;};
      specialArgs.user = "ryan";
      modules = [
        ./hosts/lumbridge/configuration.nix
        ./hosts/lumbridge/hardware-configuration.nix
        ./programs/vscodium.nix
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
      specialArgs = {inherit inputs outputs system pkgs extensions vscode-with-extensions vscodium;};
      specialArgs.user = "ryan";
      modules = [ 
        ./hosts/roshar/configuration.nix 
        ./hosts/roshar/hardware-configuration.nix
        ./programs/vscodium.nix
        { 
          # Networking
          networking.hostName = "roshar"; 

          # Bootloader.
          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;
        }
      ];
    };
  };
}
