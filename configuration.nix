{ config, lib, pkgs, ... }:

{
  imports = [
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/lenovo/thinkpad/t490"
    ./hardware-configuration.nix
  ];

  boot = {
    initrd.luks.devices = {
      "nix".device = "/dev/disk/by-uuid/3eb4b259-03fc-4999-87c2-8dbe55b42a81";
      "swap".device = "/dev/disk/by-uuid/72db6411-c8af-4a6b-a6ae-28a2b79bcae2";
    };
    kernelPackages = pkgs.linuxPackages_zen;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  documentation.man.man-db.enable = true;

  environment = {
    plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
      gwenview
      kate
      konsole
      kwrited
      plasma-browser-integration
    ];
    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATH = "/home/reeph/.steam/root/compatibilitytools.d";
    };
    systemPackages = with pkgs; [
      # TESTING
      # CLIs
      apple-cursor
      atuin
      bat
      btop
      clang
      deno
      dust
      efibootmgr
      evcxr
      evil-helix
      fastfetch
      fzf
      git
      gh
      gnumake
      go
      gopls
      lazygit
      lsd
      lua
      lunarvim
      nvtopPackages.intel
      pkg-config
      python312
      python312Packages.pynvim
      ruff
      rustup
      ripgrep
      starship
      tealdeer
      tk
      tree-sitter
      ventoy-full
      wasm-pack
      yt-dlp
      zellij
      zoxide
      # GUI Apps
      alacritty
      audacity
      bottles
      handbrake
      haruna
      heroic
      itch
      kdePackages.koko
      kdePackages.partitionmanager
      keepassxc
      librewolf
      lutris
      obsidian
      prismlauncher
      protonup
      sameboy
      spotify
      sqlitebrowser
      usbutils
      vesktop
      vscodium
      wineWowPackages.stable
      xclicker
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
    steam-hardware.enable = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  networking = {
    hostName = "APOLLO";
    networkmanager.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

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
    flatpak.enable = true;
    fprintd.enable = true;
    mullvad-vpn.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;
      pulse.enable = true;
    };
    printing = {
      enable = true;
      drivers = [ pkgs.brlaser ];
    };
    xserver = {
      # libinput.enable = true;
      xkb = {
        layout = "us";
        options = "eurosign:e, caps:escape";
        variant = "";
      };
    };
  };

  time.timeZone = "America/New_York";

  users = {
    defaultUserShell = pkgs.fish;
    users.reeph = {
      isNormalUser = true;
      description = "sanguine";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = []; # with pkgs; [];
    };
  };

  virtualisation.virtualbox.host.enable = true;

  system = {
    autoUpgrade = {
      enable = true;
      allowReboot = true;
      rebootWindow = { lower = "03:00"; upper = "05:30"; };
    };
    copySystemConfiguration = true;
    stateVersion = "24.11";
  };
}

