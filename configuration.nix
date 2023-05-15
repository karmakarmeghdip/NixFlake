# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelParams = [ "quiet" ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub = {
    enable = true;
    devices = [ "nodev" ];
    efiSupport = true;
    configurationLimit = 5;
    extraEntries = ''
    menuentry "PrimeOS" { 
      set android=/android
      insmod all_video
      search --set=root --file $android/kernel
      linux $android/kernel quiet root=/dev/ram0 androidboot.selinux=permissive acpi_sleep=s3_bios,s3_mode SRC=$android
      initrd $android/initrd.img
  }
    '';
  };

  boot.plymouth = {
      enable = true;
      themePackages = [ (import ./derivations/adi1090x_plymouth.nix pkgs) ];
      theme = "lone";
    };

  boot.supportedFilesystems = [ "ntfs" ];

  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 6 * 1024;
  } ];

  networking.hostName = "meghdipNix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.desktopManager.xterm.enable = false;
  services.greetd = {
      enable = true;
      settings = {
          default_session = {
              command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
            };
        };
    };

  # Configure keymap in X11
  # services.xserver = {
    # layout = "us";
    # xkbVariant = "";
  # };

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # services.input-remapper = {
      # enable = true;
    # };

  services.gvfs.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;
  security.rtkit.enable = true;
  security.polkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # virtualisation = {
    # waydroid.enable = true;
    # lxd.enable = true;
    # libvirtd.enable = true;
  # };

  environment.variables.NIXOS_OZONE_WL = "1";

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.meghdip = {
    isNormalUser = true;
    description = "Meghdip Karmakar";
    extraGroups = [ "networkmanager" "wheel"  ];
    shell = pkgs.fish;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    lzip
    sqlite
    # (python3.withPackages (ps: with ps; [requests tqdm dbus-python]))
    git
    mpv
    lutris
    gamemode
    gamescope
    # virt-manager
    pcmanfm
    scrcpy
    # gnome.gnome-tweaks
    # gnomeExtensions.gamemode
    # gnomeExtensions.dash2dock-lite
    # gnomeExtensions.gsconnect
    # gnomeExtensions.blur-my-shell
    # gnomeExtensions.clipboard-indicator-2
    # gnomeExtensions.dash-to-dock
    # gnomeExtensions.appindicator
    # gnomeExtensions.vitals
  ];

  # Add 32-bit support for wine
  # hardware.opengl.enable = true;
  # hardware.opengl.driSupport = true;
  # hardware.opengl.driSupport32Bit = true;
  # hardware.opengl.extraPackages = [ pkgs.mesa.drivers ];

  # environment.gnome.excludePackages = (with pkgs; [
    # gnome-photos
    # gnome-tour
  # ]) ++ (with pkgs.gnome; [
    # gnome-contacts
    # gnome-maps
    # gnome-weather
    # gnome-logs
    # gnome-music
    # gnome-photos
    # epiphany
    # yelp
    # gnome-tour
    # gnome-usage
    # gnome-weather
  # ]);
  programs.dconf.enable = true;
  programs.fish.enable = true;

  # System Fonts
  fonts.fonts = with pkgs; [
    fira-code
    fira-code-symbols
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable gnome-settings-daemon
  # services.udev.packages = with pkgs; [
    # gnome.gnome-settings-daemon
  # ];

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 19000 ];
  networking.firewall.allowedUDPPorts = [ 19000 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" "https://ezkea.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];
  };
}
