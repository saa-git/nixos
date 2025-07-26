{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  
  imports = [
    ./hardware-configuration.nix
    (let
      module = fetchTarball {
        name = "source";
        url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.3-1.tar.gz";
        sha256 = "sha256-KYMUrTV7H/RR5/HRnjV5R3rRIuBXMemyJzTLi50NFTs=";
      };
      lixSrc = fetchTarball {
        name = "source";
        url = "https://git.lix.systems/lix-project/lix/archive/2.93.3.tar.gz";
        sha256 = "sha256-Oqw04eboDM8rrUgAXiT7w5F2uGrQdt8sGX+Mk6mVXZQ=";
      };
      in import "${module}/module.nix" { lix = lixSrc; }
    )
  ];
  
  boot = {
    initrd.luks.devices = {
      "luks-c76672c5-ac01-4d02-9fa3-eb2538607d77".device = "/dev/disk/by-uuid/c76672c5-ac01-4d02-9fa3-eb2538607d77";
    };
    kernelPackages = pkgs.linuxPackages_zen;
    loader = {
      efi.canTouchEfiVariables = true;
      limine.enable = true;
    };
  };
  
  environment = {
    plasma6.excludePackages = with pkgs.kdePackages; [
      gwenview
      kate
      konsole
      kwrited
    ];
    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/reeph/.steam/root/compatibilitytools.d";
    };
    systemPackages = with pkgs; [
      # Testing

      # CLIs
      aerc
      btop
      cava
      dust
      efibootmgr
      evcxr
      eza
      fastfetch
      fd
      gh
      graphviz
      helix
      jre17_minimal
      jre21_minimal
      nvtopPackages.intel
      ripgrep
      shellcheck
      tealdeer
      tk-9_0
      tree-sitter
      wl-clip-persist
      wl-clipboard
      yt-dlp
      # GUIs
      audacity
      bottles
      kdePackages.filelight
      ghostty
      handbrake
      haruna
      itch
      kdePackages.kdenlive
      keepassxc
      kdePackages.koko
      lutris
      mangayomi
      melonDS
      mgba
      mullvad-browser
      obsidian
      kdePackages.partitionmanager
      ppsspp
      prismlauncher
      protonup
      sameboy
      sqlitebrowser
      ungoogled-chromium
      # ventoy
      vesktop
      wineWowPackages.stable
      xclicker
      zed-editor
    ];
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
      # allowedTCPPorts = [ ... ];
      # allowedUDPPorts = [ ... ];
    };
    hostName = "APOLLO-13";
    networkmanager.enable = true;
    proxy = {
      # default = "http://user:password@proxy:port/";
      # noProxy = "127.0.0.1,localhost,internal.domain";
    };
  };
  
  nixpkgs.config.allowUnfree = true;
  
  programs = {
    bat.enable = true;
    firejail.enable = true;
    fish = {
      enable = true;
      useBabelfish = true;
      vendor = {
        completions.enable = true;
        config.enable = true;
        functions.enable = true;
      };
    };
    fzf.fuzzyCompletion = true;
    gamemode.enable = true;
    git.enable = true;
    gnupg.agent = {
      enable = true;
      # enableSSHSupport = true;
    };
    java.enable = true;
    lazygit.enable = true;
    nano.enable = false;
    starship.enable = true;
    steam = {
      enable = true;
      extest.enable = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
    };
    television = {
      enable = true;
      enableFishIntegration = true;
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
  
  security.rtkit.enable = true;
  
  services = {
    # Desktop Environment
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
    # System Utilites
    atuin.enable = true;
    # dante.enable = true;
    flatpak.enable = true;
    fprintd.enable = true;
    mullvad-vpn.enable = true;
    # openssh.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
    };
    printing = {
      enable = true;
      browsed.enable = true;
      cups-pdf.enable = true;
    };
    speechd.enable = true;
  };
  
  # Do not change this value without due diligence.
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11";

  time.timeZone = "America/New_York";

  users.users.reeph = {
    isNormalUser = true;
    description = "Sanguine";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };
    virtualbox = {
      guest.enable = true;
      host = {
        enable = true;
        addNetworkInterface = false;
        enableKvm = true;
      };
    };
  };
}
