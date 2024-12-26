# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/lenovo/thinkpad/t490"
    ./hardware-configuration.nix
  ];

  boot = {
    initrd.luks.devices = {
      "swap".device = "/dev/disk/by-uuid/";
      "root".device = "/dev/disk/by-uuid/";
      "home".device = "/dev/disk/by-uuid/";
    };
    kernelPackages = pkgs.linuxPackages_zen;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  documentation.man.man-db.enable = true;

  environment = {
    plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
      gwenview
      kate
      konsole
      kwrited
    ];
    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATH = "/home/reeph/.local/share/Steam/compatibilitytools.d";
    };
    systemPackages = with pkgs; [
      # Testing
      # CLIs
      ## apple-cursor
      atuin
      bat
      btop
      clang
      deno
      dust
      efibootmgr
      evcxr
      fastfetch
      fzf
      git
      gh
      gnumake
      go
      gopls
      lazygit
      linuxKernel.packages.linux_zen.cpupower
      lsd
      lua
      neovim
      nodejs_23
      nvtopPackages.intel
      ripgrep
      ruff
      rustup
      skim
      starship
      tealdeer
      tk
      tree-sitter
      uv
      vagrant
      ventoy
      yt-dlp
      zellij
      zig
      zls
      zoxide
      # GUI Apps
      audacity
      bottles
      brave
      discord-ptb
      gfn-electron
      handbrake
      haruna
      heroic
      kdePackages.filelight
      kdePackages.koko
      kdePackages.kwalletmanager
      kdePackages.okular
      kdePackages.partitionmanager
      keepassxc
      kitty
      lutris
      obsidian
      prismlauncher
      protonup-qt
      sameboy
      sqlitebrowser
      wineWowPackages.stable
      xclicker
      zed-editor
    ];
  };

  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
  ];

  hardware = {
    bluetooth.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    steam-hardware.enable  = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  networking = {
    hostName = "APOLLO";
    networkmanager.enable = true;
    # firewall = {
    #   allowedTCPPorts = [];
    #   allowedUDPPorts = [];
    # };
  };

  nixpkgs.config = { allowUnfree = true; };

  programs = {
    fish = {
      enable = true;
      useBabelfish = true;
      vendor = {
        completions.enable = true;
        config.enable = true;
        functions.enable = true;
      };
    };
    gamemode.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    nano.enable = false;
    steam = {
      enable = true;
      extest.enable = true;
      gamescopeSession.enable = true;
    };
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    fprintd.enable = true;
    mullvad-vpn.enable = true;
    # openssh.enable = true;
    pipewire = {
      enable = true;
      jack.enable = true;
      # extraConfig.jack = {};
    };
    printing = {
      enable = true;
      drivers = [ pkgs.brlaser ];
    };
  };

  system = {
    autoUpgrade = {
      enable = true;
      allowReboot = true;
      rebootWindow = { lower = "03:00"; upper = "05:30"; };
    };
    copySystemConfiguration = true;
    stateVersion = "24.11";
  };

  time.timeZone = "America/New_York";

  users = {
    defaultUserShell = pkgs.fish;
    users.reeph = {
      isNormalUser = true;
      description = "Sanguine";
      extraGroups = [ "networkmanager" "wheel" ];
      # packages = with pkgs; [];
    };
  };

  virtualisation.virtualbox = {
    guest.enable = true;
    host.enable = true;
  };
}

