{
  description = "NixOS configuration";

  inputs = {
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    flake-utils.follows = "nix-vscode-extensions/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "github:Ryan-Jeziorski/nix-vim-config/more_plugins";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    self, 
    ...
  }: 
  inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" "aarch64-linux" ];

    flake = {
      nixosConfigurations.latitude-nix = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit self inputs ;};
        specialArgs.user = "ryan";
        modules = [ 
          ./hosts/latitude-nix/configuration.nix 
          ./hosts/latitude-nix/hardware-configuration.nix
          #./programs/vscodium.nix
          {
            # Networking
            networking.hostName = "latitude-nix"; 

            # Bootloader.
            boot.loader.systemd-boot.enable = true;
            boot.loader.efi.canTouchEfiVariables = true;

            # nixvim config
            environment.systemPackages = [
              inputs.nixvim.legacyPackages.x86_64-linux.nixvim
            ];
          }
        ];
      };

      nixosConfigurations.lumbridge = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit self inputs ;};
        specialArgs.user = "ryan";
        modules = [
          ./hosts/lumbridge/configuration.nix
          ./hosts/lumbridge/hardware-configuration.nix
          #./programs/vscodium.nix
          { 
            networking.hostName = "lumbridge"; 
            # Bootloader.
            boot.loader.grub.enable = true;
            boot.loader.grub.device = "/dev/sda";
            boot.loader.grub.useOSProber = true;

            # nixvim config
            environment.systemPackages = [
              inputs.nixvim.legacyPackages.x86_64-linux.nixvim
            ];
          }
        ];
      };

      nixosConfigurations.roshar = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit self inputs ;};
        specialArgs.user = "ryan";
        modules = [ 
          ./hosts/roshar/configuration.nix 
          ./hosts/roshar/hardware-configuration.nix
          ./programs/kitty.nix
          ./programs/tmux.nix
          #./programs/vscodium.nix
          { 
            # Networking
            networking.hostName = "roshar"; 

            # Bootloader.
            boot.loader.systemd-boot.enable = true;
            boot.loader.efi.canTouchEfiVariables = true;

            # nixvim config
            environment.systemPackages = [
              inputs.nixvim.legacyPackages.x86_64-linux.nixvim
            ];
            programs.kdeconnect.enable = true;
          }
        ];
      };

      nixosConfigurations.ashyn = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit self inputs ;};
        specialArgs.user = "ryan";
        modules = [ 
          ./services/rabbitmq.nix
          ./services/caddy.nix
          ./hosts/ashyn/configuration.nix 
          ./hosts/ashyn/hardware-configuration.nix
          {
            systemd.services."hello-world" = {
              script = ''
                set -xu
                echo "hello world"
                #/run/wrappers/bin/sudo -u ryan /run/current-system/sw/bin/nix flake update --commit-lock-file --flake /home/ryan/nixos-config-files/
              '';
              serviceConfig = {
                Type = "oneshot";
                User = "root";
              };
              startAt = "*:0/5";
            };
            # Automatic Updates
            #system.autoUpgrade = {
              #enable = true;
              #flake = "/etc/nixos/";
              #flags = [
                #"--recreate-lock-file"
                #"--commit-lock-file"
                #"--flake#"
              #];
              #dates = "20:50";
            #};
            # Networking
            networking.hostName = "ashyn"; 

            # Bootloader.
            boot.loader.systemd-boot.enable = true;
            boot.loader.efi.canTouchEfiVariables = true;

            # nixvim config
            environment.systemPackages = [
              inputs.nixvim.legacyPackages.x86_64-linux.nixvim
            ];
          }
        ];
      };

      nixosConfigurations.braize = inputs.nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {inherit self inputs ;};
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
