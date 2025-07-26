{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  
  boot = {
    extraModulePackages = [ ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ ];
      luks.devices = {
        "luks-1a4da71d-61f5-4762-8356-e175090d5786".device = "/dev/disk/by-uuid/1a4da71d-61f5-4762-8356-e175090d5786";
      };
    };
    kernelModules = [ "kvm-intel" ];
  };
  
  fileSystems = {
    "/" = {
      device = "/dev/mapper/luks-1a4da71d-61f5-4762-8356-e175090d5786";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };
    "/boot" = { device = "/dev/disk/by-uuid/AA47-6C3A";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };
  
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  swapDevices = [ { device = "/dev/mapper/luks-c76672c5-ac01-4d02-9fa3-eb2538607d77"; } ];
}
