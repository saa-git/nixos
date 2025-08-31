{
  description = "Reeph's Flake for NIKE";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      NIKE = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
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
