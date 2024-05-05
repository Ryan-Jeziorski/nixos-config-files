{
  description = "A very basic flake";

   inputs = {
     nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
   };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations = {
      lumbridge = nixpkgs.lib.nixosSystem {
        system = "x86-64-linux";
        modules = [
          ./configuration.nix
          ./hardware-configurations/lumbridge/hardware-configuration.nix
          { networking.hostName = "lumbridge"; }
        ];
      };
      #myComputer = nixpkgs.lib.nixosSystem {
        #system = "x86_64-linux";
        #modules = [
          #./configuration.nix
          #./pc-configuration.nix
          #{ networking.hostname = "mycomputer"; }
        #];
      #}
    };
  };
}
