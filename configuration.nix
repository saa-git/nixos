{ config, pkgs, ... }:

{
  nixpkgs.overlays = [ (final: prev: {
    inherit (final.lixPackageSets.git)
      nixpkgs-review
      nix-direnv
      nix-eval-jobs
      nix-fast-jobs
      colmena;
  }) ];

  nix.package = pkgs.lixPackageSets.git.lix;
  
  imports = [ ./hardware-configuration.nix ];
  
  boot = {
    initrd.luks.devices = {
      # "nixos".device = "";
      # "swap".device = "";
    };
    kernelPackages = pkgs.linuxPackages_zen;
    loader = {
      efi.canTouchEfiVariables = true;
      limine.enable = true;
    };
  };

  documentation.man.man-db.enable = true;
  
  environment = {
    plasma6.excludePackages = with pkgs.kdePackages; [
      kate
      konsole
      kwrited
      spectacle
    ];
    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
    };
    # systemPackages = with pkgs; [];
  };
  
  fonts.packages = with pkgs; [
    nerd-fonts.geist-mono
    nerd-fonts.fira-code
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
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
  
  networking = {
    firewall = {
      # allowedTCPPorts = [ ];
      # allowedUDPPorts = [ ];
    };
    hostName = "NIKE";
    networkmanager.enable = true;
    proxy = {
      # default = "http://user:password@proxy:port/";
      # noProxy = "127.0.0.1,localhost,internal.domain";
    };
  };
  
  nixpkgs.config.allowUnfree = true;
  
  programs = {
    firejail.enable = true;
    fish.enable = true;
    gnupg.agent = {
      enable = true;
      # enableSSHSupport = true;
    };
    # hyprland = {
    #   enable = true;
    #   withUWSM = true;
    #   xwayland.enable = true;
    # };
    nano.enable = false;
    steam = {
      enable = true;
      extest.enable = true;
      gamescopeSession = {
        enable = true;
        # args = [ ];
        # env = [ ]
        # steamArgs = [ ];
      };
      protontricks.enable = true;
    };
  };
  
  security.rtkit.enable = true;
  
  services = {
    # Desktop Environment
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    # Utilities
    # dante = {
    #   enable = true;
    #   config = ""
    # };
    flatpak.enable = true;
    fprintd.enable = true;
    mullvad-vpn.enable = true;
    openssh.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };  
    printing = {
      enable = true;
      browsed.enable = true;
      cups-pdf.enable = true;
    };
    speechd.enable = true;
  };

  system = {
    autoUpgrade = {
      enable = true;
      allowReboot = true;
      dates = "03:00";
      flags = [
        "--flake"
        "/etc/nixos/#NIKE"
      ];
    };
    # Do not change this value without due diligence.
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    stateVersion = "25.11"; # Did you read the comment?
  };

  time.timeZone = "America/New_York";
  
  users = {
    users = {
      reeph = {
        description = "Sanguine";
        extraGroups = [ "networkmanager" ];
        group = "wheel";
        isNormalUser = true;
        # packages = with pkgs; [
        #   # Testing
        #   #
        # ];
        shell = pkgs.fish;
      };
    };
  };

  virtualisation = {
    libvirtd = {
      enable = true;
    };
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };
  };
}
