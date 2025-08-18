{
  description = "Reeph's Flake for APOLLO-13";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # This build is broken as of the latest 25.11pre build (2025-08-15).
    # lix = {
    #   url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.3-1.tar.gz";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    zen = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, home-manager, nixos-hardware, nixpkgs, zen }: {
    nixosConfigurations = {
      APOLLO-13 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          # lix.nixosModules.default
          nixos-hardware.nixosModules.lenovo-thinkpad-t490
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.reeph = { pkgs, ... }: {
              home.username = "reeph";
              home.homeDirectory = "/home/reeph";
              programs.home-manager.enable = true;
              home.packages = with pkgs; [
                zen.packages."${system}".twilight
              ];
              home.stateVersion = "25.11";
            };
          }
        ];
      };
    };
  };
}
