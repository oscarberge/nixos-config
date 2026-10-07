# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, pkgs-unstable, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../pkgs/ntnu-vpn
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.nix-ld.enable = true;

  networking.hostName = "zenith"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nb_NO.UTF-8";
    LC_IDENTIFICATION = "nb_NO.UTF-8";
    LC_MEASUREMENT = "nb_NO.UTF-8";
    LC_MONETARY = "nb_NO.UTF-8";
    LC_NAME = "nb_NO.UTF-8";
    LC_NUMERIC = "nb_NO.UTF-8";
    LC_PAPER = "nb_NO.UTF-8";
    LC_TELEPHONE = "nb_NO.UTF-8";
    LC_TIME = "nb_NO.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "no";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "no";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."osbe" = {
    isNormalUser = true;
    description = "Oscar Berge";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  security.sudo.wheelNeedsPassword = false;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    ghostty
    fuzzel
    waybar
    waylock
    yazi
    grim
    slurp
    pavucontrol
    libnotify
    swaynotificationcenter
    batsignal
    adwaita-icon-theme
    wl-clipboard
    cliphist
    wlsunset
    bluetui
    openconnect
    btop
    python3
    uv
    bun
    prismlauncher
    vscodium
    bibata-cursors
    pkgs-unstable.opencode
  ];

  programs.git = {
    enable = true;
    config = {
      user.name = "Oscar Berge";
      user.email = "oscar.berge.mail@gmail.com";
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.bat.enable = true;

  programs.firefox.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  programs.steam.enable = true;
  programs.gamemode.enable = true;

  programs.starship = {
    enable = true;
    settings = {
      shlvl = {
        disabled = false;
        threshold = 2;
      };
      directory.style = "bold green";
    };
    presets = [
      "nerd-font-symbols"
    ];
  };

  programs.localsend.enable = true;

  virtualisation.docker.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "greeter";
        command = lib.getExe' pkgs.tuigreet "tuigreet";
      };
    };
  };

  security.pam.services.waylock = {};

  security.polkit.enable = true; # Polkit daemon
  security.soteria.enable = true; # Polkit agent

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "0001:0001:09b4e68d" ];
      settings.main = {
        "leftmeta+leftshift+f23" = "rightcontrol";
      };
    };
  };

  services.power-profiles-daemon.enable = true;

  fonts = {
    enableDefaultPackages = true;
    
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      inter
      nerd-fonts.fira-code
    ];

    fontconfig.defaultFonts = {
      serif     = [ "Noto Serif" ];
      sansSerif = [ "Noto Sans" ];
      monospace = [ "FiraCode Nerd Font" ];
      emoji     = [ "Noto Color Emoji" ];
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
