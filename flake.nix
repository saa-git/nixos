{
  description = "Reeph's Flake for APOLLO-13";

  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware }: {
    nixosConfigurations = {
      APOLLO-13 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-hardware.nixosModules.lenovo-thinkpad-t490
          ./configuration.nix
        ];
      };
    };
  };
}
