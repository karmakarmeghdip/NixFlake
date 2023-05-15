{ pkgs, hyprland, ... } : {

    imports = [
    hyprland.homeManagerModules.default
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    extraConfig = ''# Init
exec-once = systemctl --user import-environment DISPLAY WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP
exec-once = hyprctl setcursor Catppuccin-Mocha-Blue-Cursors 24
exec-once = mako
exec-once = swww init
exec-once = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &

# Input
input {
  touchpad {
      natural_scroll = true
    }
  }
gestures {
    workspace_swipe = true
  }

# Decorations
decoration {
    rounding = 15
    blur_size = 10
    blur_passes = 3
  }

general {
    gaps_in = 5
    gaps_out = 5
  }

# Window Rules
windowrulev2 = float,class:^(firefox)$,title:^(Picture-in-Picture)$
windowrulev2 = float,class:^(xdg-desktop-portal-gtk)$

# KeyBindings!!
bind = SUPER, Return, exec, kitty
bind = SUPER, B, exec, firefox
bind = SUPER, D, exec, fuzzel
bind = SUPER, Q, killactive
bind = SUPER SHIFT, Q, exit
bind = SUPER, F, fullscreen

bind = ,XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
bind = ,XF86AudioRaiseVolume,exec,wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
bind = ,XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bind = ,XF86AudioMicMute,exec,wpctl set-mute @DEFAULT_SOURCE@ toggle

bind = ,PRINT,exec,grim -o $(hyprctl monitors | grep -B 10 'focused: yes' | grep 'Monitor' | awk '{ print $2 }') -t jpeg ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%m-%s).jpg

bind=SUPER,1,workspace,1
bind=SUPER,2,workspace,2
bind=SUPER,3,workspace,3
bind=SUPER,4,workspace,4
bind=SUPER,5,workspace,5
bind=SUPER,6,workspace,6
bind=SUPER,7,workspace,7
bind=SUPER,8,workspace,8
bind=SUPER,9,workspace,9
bind=SUPER,0,workspace,10

bind=SUPER SHIFT,1,movetoworkspace,1
bind=SUPER SHIFT,2,movetoworkspace,2
bind=SUPER SHIFT,3,movetoworkspace,3
bind=SUPER SHIFT,4,movetoworkspace,4
bind=SUPER SHIFT,5,movetoworkspace,5
bind=SUPER SHIFT,6,movetoworkspace,6
bind=SUPER SHIFT,7,movetoworkspace,7
bind=SUPER SHIFT,8,movetoworkspace,8
bind=SUPER SHIFT,9,movetoworkspace,9
bind=SUPER SHIFT,0,movetoworkspace,10
    '';
  };

    home.packages = with pkgs; [
      firefox
      httpie
      tldr
      vlc
      obsidian
      brightnessctl
      swww
      fuzzel
      grim
      imv
      nitch
      neofetch
      amberol
      ffmpeg
      fragments
      catppuccin-papirus-folders
      (import ./derivations/miru.nix pkgs)
    ];
    nixpkgs.config.allowUnfree = true;
    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        catppuccin.catppuccin-vsc
        jnoortheen.nix-ide
        github.copilot
        esbenp.prettier-vscode
        github.codespaces
        ms-vscode-remote.remote-ssh
      ];
    };

    programs.git.userName = "karmakarmeghdip";
    programs.git.userEmail = "karmakarmeghdip@gmail.com";

    programs = {
      htop.enable = true;
      fzf.enable = true;
      jq.enable = true;
      bat.enable = true;
      command-not-found.enable = true;
      dircolors.enable = true;
      yt-dlp = {
          enable = true;
        };
      # direnv = {
      #   enable = true;
      #   nix-direnv = {
      #     enable = true;
      #     # enableFlakes = true;
      #   };
      # };
    };

    programs.kitty = {
      enable = true;
      theme = "Catppuccin-Mocha";
      font = {
        name = "FiraCode Nerdfont";
        package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
      };

      settings = {
        wayland_titlebar_color = "background";
        # dynamic_background_opacity = "yes";
        background_opacity = "0.3";
      };
    };

    # gtk = {
    #  enable = true;
    #  theme = {
    #    name = "Catppuccin-Mocha";
    #    package = pkgs.catppuccin-gtk.override {
    #     # accents = [ "pink" ];
    #     # size = "compact";
    #     # tweaks = [ "rimless" "black" ];
    #     variant = "mocha";
    #   };
    #  };
    #  iconTheme = {
    #    name = "Catppuccin-Mocha-Papirus";
    #    package = ;
    #  };
    # };

    home.pointerCursor = {
      name = "catppuccin-cursors";
      package = pkgs.catppuccin-cursors.mochaBlue;
      x11.defaultCursor = "catppuccin-cursors";
    };

    programs.fish = { 
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
      '';
    };

    # programs.eww = {
    #    enable = true;
    #    package = pkgs.eww-wayland;
    #    
    #  }

    services.mako = {
        enable = true;
        defaultTimeout = 5000;
        anchor = "bottom-right";
        backgroundColor = "#1e1e2e";
        textColor = "#cdd6f4";
        borderColor = "#89b4fa";
        progressColor = "over #313244";
        extraConfig = ''
          [urgency=high]
          border-color=#fab387
        '';
      };

    programs.starship = {
      enable = true;
      
    };

    programs.waybar = {
        enable = true;
        systemd.enable = true;
        package = hyprland.packages.${ pkgs.stdenv.hostPlatform.system }.waybar-hyprland;
        settings = {
      "bar" = {
        # output = [ "eDP-1" ];
        # mode = "dock";
        layer = "top";
        position = "top";
        height = 24;
        width = null;
        exclusive = true;
        passthrough = false;
        # spacing = 4;
        margin = null;
        margin-top = 0;
        margin-bottom = 0;
        margin-left = 0;
        margin-right = 0;
        fixed-center = true;
        ipc = true;

        # Modules display
        modules-left = [ "wlr/workspaces" ];
        modules-center = [  ];
        modules-right = [
          # "idle_inhibitor"
          "network"
          "cpu"
          "memory"
          "wireplumber"
          # "backlight"
          "battery"
          "clock"
          "tray"
        ];

        # Modules
        "wlr/workspaces" = {
          format = "{name}";
          on-click = "activate";
          sort-by-number = true;
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };
        # idle_inhibitor = {
        #   format = "{icon}";
        # };
        wireplumber = {
          format = "{icon} {volume}%";
          format-muted = " Mute";
          # format-bluetooth = " {volume}% {format_source}";
          # format-bluetooth-muted = " Mute";
          # format-source = " {volume}%";
          # format-source-muted = "";
          # format-icons = {
            # headphone = "";
            # hands-free = "";
            # headset = "";
            # phone = "";
            # portable = "";
            # car = "";
            # default = [ "" "" "" ];
          # };
          format-icons = [ "" "" "" ];
          # scroll-step = 5.0;
          tooltip = false;
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-right = "helvum";
          # smooth-scrolling-threshold = 1;
        };
        network = {
          format-wifi = " {essid}";
          format-ethernet = " {bandwidthTotalBytes}";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "睊";
          tooltip = true;
          tooltip-format = ''
            {ifname}
            {ipaddr}/{cidr}
            Up: {bandwidthUpBits}
            Down: {bandwidthDownBits}'';
        };
        cpu = {
          format = " {usage}%";
          on-click = "kitty htop";
        };
        memory = {
          format = " {used:0.1f}G/{total:0.1f}G ";
          interval = 5;
          on-click = "kitty htop";
        };
        backlight = {
          interval = 2;
          align = 0;
          rotate = 0;
          #"device": "amdgpu_bl0",
          format = "{icon} {percent}%";
          format-icons = [ "" "" "" "" ];
          on-click = "";
          on-click-middle = "";
          on-click-right = "";
          on-update = "";
          on-scroll-up = "brightnessctl s 5%+";
          on-scroll-down = "brightnessctl s 5%-";
          smooth-scrolling-threshold = 1;
        };
        battery = {
          interval = 60;
          align = 0;
          rotate = 0;
          full-at = 100;
          design-capacity = false;
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon}  {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = "  {capacity}%";
          format-full = "{icon}  Full";
          # format-good = "";
          format-alt = "{icon} {time}";
          format-icons = [ "" "" "" "" "" ];
          format-time = "{H}h {M}min";
          tooltip = true;
        };
        clock = {
          interval = 60;
          align = 0;
          rotate = 0;
          tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
          format = " {:%I:%M %p}";
          format-alt = " {:%a %b %d, %G}";
        };
        tray = {
          icon-size = 14;
          spacing = 6;
        };
      };
    };
    style = builtins.readFile ./assets/waybar.catppuccin.css;
      };

    xdg = {
      enable = true;
      configFile = {
        "nvim" = {
          source = ./nvim;
          recursive = true;
        };

        "gtk-4.0" = {
          source = ./.themes/Catppuccin-Mocha-Standard-Blue-Dark/gtk-4.0;
          recursive = true;
        };
      };
    };

    home.file.".themes" = {
        source = ./.themes;
        recursive = true;
      };
    
    home.stateVersion = "22.11";
  }
