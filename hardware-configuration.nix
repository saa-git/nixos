{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    extraModulePackages = [ ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ ];
      luks.devices = {
        "nix".device = "/dev/disk/by-uuid/3eb4b259-03fc-4999-87c2-8dbe55b42a81";
        "swap".device = "/dev/disk/by-uuid/72db6411-c8af-4a6b-a6ae-28a2b79bcae2";
      };
    };
    kernelModules = [ "kvm-intel" ];
  };

  fileSystems = {
    "/" = {
     device = "/dev/disk/by-label/NixOS";
     fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  swapDevices = [ { device = "/dev/disk/by-label/SWAP"; } ];
}
