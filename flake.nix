{
  description = "Reeph's Flake for NIKE";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    homan = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hware.url = "github:NixOS/nixos-hardware/master";
    zen = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, homan, hware, zen }: {
    nixosConfigurations = {
      NIKE = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          
          hware.nixosModules.lenovo-thinkpad-t490
          
          homan.nixosModules.home-manager {
            home-manager = {
              users.reeph = { pkgs, lib, ... }: {
                home = {
                  homeDirectory = "/home/reeph";
                  packages = with pkgs; [
                    # CLIs
                    #
                    apple-cursor
                    cups-brother-hll2350dw
                    deno
                    dust
                    # efibootmgr
                    evcxr
                    graphviz
                    nixd
                    nvtopPackages.intel
                    python313Packages.kde-material-you-colors
                    rustup
                    shellcheck
                    smartmontools
                    speechd
                    spirv-tools
                    tk-9_0
                    tree-sitter
                    wget
                    wl-clip-persist
                    wl-clipboard
                    zig_0_15
                    
                    # GUIs
                    #
                    audacity
                    # azahar
                    bottles
                    cider-2
                    gfn-electron
                    ghostty
                    gnome-boxes
                    handbrake
                    haruna
                    itch
                    kdePackages.filelight
                    kdePackages.kdenlive
                    kdePackages.ktorrent
                    kdePackages.partitionmanager
                    krita
                    libreoffice-fresh
                    melonDS
                    mgba
                    obsidian
                    ppsspp-sdl
                    prismlauncher
                    # protonup
                    sameboy
                    # ventoy-full-qt
                    vesktop
                    # wineWow64Packages.stableFull
                    xclicker
                    zen.packages."${system}".twilight
                  ];
                  shell.enableFishIntegration = true;
                  sessionPath = [
                    "$ZLSIR"
                  ];
                  sessionVariables = {
                    # UTILS
                    #
                    CONFIG = "$HOME/.config";
                    CODE_EDITOR = "zeditor";

                    # ZIG
                    #
                    ZOME = "$HOME/.zig";
                    ZIR = "$ZOME/zig";
                    ZLIR = "$ZOME/zigl";
                    ZLSIR = "$ZOME/zls";
                  };
                  stateVersion = "25.11";
                  username = "reeph";
                };
                manual.html.enable = true;
                programs = {
                  aerc.enable = true;
                  bat.enable = true;
                  btop.enable = true;
                  cava.enable = true;
                  eza = {
                    enable = true;
                    colors = "auto";
                    git = true;
                    icons = "auto";
                    # theme = {};
                  };
                  fastfetch.enable = true;
                  fd = {
                    enable = true;
                    hidden = true;
                  };
                  fish = {
                    enable = true;
                    functions = {
                      fish_greeting = ''
                        set greeting ~/.config/fish/greeting

                        if not [ -f $greeting ]
                          echo 'nikeSH: Get New ASCII Art' > $greeting
                        end

                        cat $greeting

                        return 0
                      '';
                      zigl = ''
                        echo "[~[ZIGL: Building Latest Zig Binary]~]"
                    
                        echo "[ZIGL Step 1: Checking For Zig Binary]"
                        if not [ -f $ZLIR/build/stage3/bin/zig ]
                            echo "[Zig Binary Not Present]"
                    
                            echo "[ZIGLL Step 1.2: Check For 'Zig Latest' Directory]"
                            if [ -d $ZLIR ]
                                echo "['Zig Latest' Directory Found, Assuming Broken]"
                    
                                echo "[ZIGL Step 1.2.1: Remove Broken 'Zig Latest' Directory]"
                                rm -rf $ZLIR
                            end
                    
                            echo "[ZIGL Step 1.3: Set Up 'Zig Latest' Directory]"
                            git clone https://github.com/ziglang/zig $ZLIR
                            mkdir -p $ZLIR/build
                    
                            echo "[ZIGL Step 1.4: Build Zig Binary]"
                            cd $ZLIR/build
                            cmake ..
                            make install
                        end
                        echo "[Zig Binary Verified]"
                    
                        echo "[ZIGL Step 2: Check If Build Up To Date]"
                        cd $ZLIR
                        set pull (git pull)
                        if not [ "$pull[1]" = "Already up to date." ]
                            echo "[Zig Build Is Not Up To Date]"
                    
                            echo "[ZIGL Step 2.1: Back Up Current Binary]"
                            rename -v zig zig.bak $ZLIR/build/stage3/bin/zig
                    
                            echo "[ZIGL Step 2.2: Build Latest Binary]"
                            cd $ZLIR/build
                            cmake ..
                            make install
                        end
                        echo "[Latest Zig Binary Verified]"
                    
                        echo "[ZIGL Step 3: Verify Linking Directories Present]"
                        if not [ -d $ZIR/doc ]; or not [ -d $ZIR/lib ]
                            echo "[Missing Link Directory]"
                    
                            echo "[ZIGL Step 3.1: Create Link Directories]"
                            mkdir -p $ZIR/{doc,lib}
                        end
                        echo "[Linking Directories Verified]"
                    
                        echo "[ZIGL Step 4: Verifying Binary & Libraries Links + Documentation]"
                        if not [ -f $ZIR/zig ]; or [ $ZIR/zig -ot $ZLIR/build/stage3/bin/zig ]
                            echo "[Zig Binary Link Outdated]"
                    
                            echo '[ZIGL 4.1 Create Links + Documentation]'
                            ln -sf $ZLIR/build/stage3/bin/zig $ZIR/zig
                            ln -sf $ZLIR/build/stage3/lib/zig/* $ZIR/lib
                            curl https://ziglang.org/documentation/master/index.html -o $ZIR/doc/langref.html
                        end
                        echo "[Directory Links Copied]"
                    
                        echo "[Zig Setup Complete]"
                      '';
                      zlsl = ''
                        echo "[~[ZLSL: Building Latest ZLS Binary]~]"
                    
                        echo "[ZLSL Step 1: Check For Zig Binary]"
                        if not [ -f $ZIR/zig ]
                            echo "[Zig Binary Not Present]"
                    
                            echo "[ZLSL Step 1.1: Build Zig Binary]"
                            zigl
                    
                            if [ $status -ne 0 ]
                                echo "[Installing Zig Failed, Nothing Can Be Done Locally]"
                                return 1
                            end
                        end
                        echo "[Zig Binary Verified]"
                    
                        echo "[ZLSL Step 2: Checking For ZLS Binary]"
                        if not [ -f $ZLSIR/zig-out/bin/zls ]
                            echo "[ZLS Binary Not Present]"
                    
                            echo "[ZLSL Step 2.1: Check For 'ZLS' Directory]"
                            if [ -d $ZLSIR ]
                                echo "[ZLS Directory Found, Assuming Broken]"
                    
                                echo "[ZLSL Step 2.1.1: Remove Broken 'ZLS' Directory]"
                                rm -rf $ZLSIR
                            end
                    
                            echo "[ZLSL Step 2.2: Set Up 'ZLS' Directory]"
                            git clone https://github.com/zigtools/zls $ZLSIR
                    
                            echo "[ZLSL Step 2.3: Build ZLS Binary]"
                            cd $ZLSIR
                            zig build -Doptimize=ReleaseSafe
                            echo "[ZLS Binary Verified, Early Exit]"
                            return 0
                        end
                        echo "[ZLS Binary Verified]"
                    
                        echo "[ZLSL Step 3: Check If Build Up To Date]"
                        cd $ZLSIR
                        set pull (git pull)
                        if [ $ZIR/zig -nt $ZLSIR/zig-out/bin/zls ]; or not [ "$pull[1]" = "Already up to date." ]
                            echo "[ZLS Build Is Not Up To Date]"
                    
                            echo "[ZLSL Step 2.1: Build Latest Binary]"
                            zig build -Doptimize=ReleaseSafe
                        end
                        echo "[Latest ZLS Binary Verified]"
                      '';
                    };
                    shellAbbrs = {
                      # UTILS
                      #
                      c = "clear";
                      x = "exit";
                      # q = "qs -c ii";
                      rn = "rename";
                      rs = "exec $SHELL";
                      zv = "zig version; zls version";
                      zup = "zigl && zlsl";
                      cat = "bat --paging=never";
                      sql3 = "sqlite3";
                      mkdir = "mkdir -p";

                      # CARGO
                      #
                      cga = "cargo add";
                      cgb = "cargo build";
                      cgc = "cargo clean";
                      cgi = "cargo init";
                      cgn = "cargo new";
                      cgr = "cargo run";
                      cgcl = "cargo clippy -- -W clippy::pedantic";

                      # MULLVAD VPN
                      #
                      vac = "mullvad auto-connect set";
                      vcc = "mullvad connect -w";
                      vdc = "mullvad disconnect -w";
                      vlg = "mullvad account login < ~/.config/sec/mvvac";
                      vrl = "mullvad relay set location";
                      vsl = "mullvad status listen";
                      vst = "mullvad status";
                    };
                    shellAliases = {
                      # CONFIGS
                      #
                      ted = "$EDITOR";
                      ced = "$CODE_EDITOR";
                      egho = "ted $CONFIG/ghostty/config";
                      egre = "ted $CONFIG/fish/greeting";
                      enix = "sudo hx /etc/nixos";
                      enixc = "sudo hx /etc/nixos/configuration.nix";
                      enixf = "sudo hx /etc/nixos/flake.nix";

                      # NIXOS
                      #
                      rb = "sudo nixos-rebuild";
                      rbs = "rb switch";
                      rbs-flake = "rbs --flake /etc/nixos/#NIKE";
                    };
                  };
                  fzf.enable = true;
                  gh.enable = true;
                  git = {
                    enable = true;
                    userEmail = "sharifakab@gmail.com";
                    userName = "Sharif Abdi";
                  };
                  helix = {
                    enable = true;
                    defaultEditor = true;
                  };
                  home-manager.enable = true;
                  java = {
                    enable = true;
                    package = pkgs.jdk24;
                  };
                  keepassxc = {
                    enable = true;
                    # setting = {};
                  };
                  lazygit.enable = true;
                  lazysql.enable = true;
                  less.enable = true;
                  librewolf = {
                    enable = true;
                    # profile = {};
                  };
                  lutris = {
                    enable = true;
                    extraPackages = with pkgs; [
                      gamemode
                      gamescope
                      mangohud
                    ];
                    protonPackages = [
                      pkgs.proton-ge-bin
                    ];
                    winePackages = [
                      pkgs.wineWow64Packages.wayland
                    ];
                  };
                  mangohud = {
                    enable = true;
                    # enableSessionWide = true;
                  };
                  mpvpaper = {
                    enable = true;
                    # pauseList = ''
                    #
                    # '';
                    # stopList = ''
                    #
                    # '';
                  };
                  obsidian = {
                    enable = true;
                    # vaults = {};
                  };
                  ripgrep.enable = true;
                  skim.enable = true;
                  starship = {
                    enable = true;
                    enableTransience = true;
                    settings = {
                      character = {
                        success_symbol = "[❯](purple)";
                        error_symbol = "[❯](red)";
                        vimcmd_symbol = "[❮](green)";
                      };
                      cmd_duration = {
                        format = "[$duration]($style) ";
                        style = "yellow";
                      };
                      directory.style = "blue";
                      format = lib.concatStrings [
                        "$username"
                        "$hostname"
                        "$directory"
                        "$git_branch"
                        "$git_state"
                        "$cmd_duration"
                        "$line_break"
                        "$python"
                        "$character"
                      ];
                      git_branch = {
                        format = "[$branch]($style)";
                        style = "bright-black";
                      };
                      git_state = {
                        format = "\([$state( $progress_current/$progress_total)]($style)\)";
                        style = "bright-black";
                      };
                      git_status = {
                        format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
                        style = "cyan";
                        conflicted = "​";
                        untracked = "​";
                        modified = "​";
                        staged = "​";
                        renamed = "​";
                        deleted = "​";
                        stashed = "≡";
                      };
                      python = {
                        format = "[$virtualenv]($style) ";
                        style = "bright-black";
                      };
                    };
                  };
                  tealdeer.enable = true;
                  television.enable = true;
                  uv.enable = true;
                  vesktop.enable = true;
                  yt-dlp.enable = true;
                  zed-editor = {
                    enable = true;
                    extensions = [
                      "git-firefly"
                      "fish"
                      "html"
                      "material-icon-theme"
                      "nix"
                      "nvim-nightfox"
                      "rust-snippets"
                      "zig"
                    ];
                    # extraPackages = with pkgs; [];
                    userSettings = {
                      disable_ai = true;
                      minimap = {
                        show = "auto";
                      };
                    };
                  };
                  zoxide = {
                    enable = true;
                    options = [
                      "--cmd"
                      "cd"
                    ];
                  };
                };
                services.home-manager = {
                  autoExpire = {
                    enable = true;
                    frequency = "weekly";
                    store.cleanup = true;
                    timestamp = "-14 days";
                  };
                };
              };
              useGlobalPkgs = true;
              useUserPackages = true;
            };
          }
        ];
      };
    };
  };
}
