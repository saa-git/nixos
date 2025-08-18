{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixVersions.git;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  
  imports = [ ./hardware-configuration.nix ];
  
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    loader = {
      efi.canTouchEfiVariables = true;
      limine.enable = true;
    };
  };
  
  environment = {
    plasma6.excludePackages = with pkgs.kdePackages; [
      kate
      konsole
      kwrited
    ];
    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/reeph/.steam/root/compatibilitytools.d";
    };
    # systemPackages = with pkgs; [ ];
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
    gamescope.enable = true;
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
      gamescopeSession = {
        enable = true;
        # args = [ ];
        # env = [ ]
        # steamArgs = [ ];
      };
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
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    # Utilities
    # atuin.enable = true;
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
  
  # Do not change this value without due diligence.
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

  time.timeZone = "America/New_York";
  
  users = {
    # defaultUserShell = pkgs.fish;
    users = {
      reeph = {
        description = "Sanguine";
        extraGroups = [ "networkmanager" ];
        group = "wheel";
        isNormalUser = true;
        packages = with pkgs; [
          # Testing
          # CLIs
          aerc
          atuin
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
          nixd
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
          ghostty
          handbrake
          haruna
          itch
          keepassxc
          kdePackages.filelight
          kdePackages.kdenlive
          kdePackages.partitionmanager
          krita
          librewolf
          lutris
          melonDS
          mgba
          obsidian
          ppsspp-sdl
          prismlauncher
          protonup
          sameboy
          sqlitebrowser
          # ventoy
          vesktop
          wineWow64Packages.stableFull
          xclicker
          zed-editor
        ];
        shell = pkgs.fish;
      };
    };
  };
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };
    virtualbox = {
      # guest.enable = true;
      host.enable = true;
    };
  };
}
