{
  description = "A very basic flake";

   inputs = {
     nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
     nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
     #nix-vscode-extensions.follows = "nixpkgs";
     #nixpkgs.follows = "nix-vscode-extensions/nixpkgs";
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
          #{
          users.users.ryan = {
            packages = with nixpkgs; [
              logseq
            ];
#            (vscode-with-extensions.override {
#              vscode = vscodium;
#              vscodeExtensions = with vscode-extensions.extensions.x86_64-linux; [
#                vscode-marketplace.bbenoist.nix
#                vscode-marketplace.rust-lang.rust-analyzer
#                vscode-marketplace.vscodevim.vim
#                open-vsx.jeanp413.open-remote-ssh
            #})
	  #];
          };#}
        #];
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
