{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  
  boot = {
    extraModulePackages = [ ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ ];
      luks.devices = {
        "".device = "";
      };
    };
    kernelModules = [ "kvm-intel" ];
  };
  
  fileSystems = {
    "/" = {
      device = "";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };
    "/boot" = { device = "";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };
  
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  swapDevices = [ { device = ""; } ];
}
