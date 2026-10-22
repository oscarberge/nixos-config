{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  shares = [
    "arkivet-uka"
    "felles"
    "fg"
    "fg-sekk"
    "fg-web"
    "oscarber"
  ];

  mkShare =
    name:
    lib.nameValuePair "/mnt/samfundet/${name}" {
      device = "//samba.samfundet.no/${name}";
      fsType = "cifs";
      options = [
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout=60"
        "x-systemd.device-timeout=5s"
        "x-systemd.mount-timeout=5s"
        "credentials=/etc/smb-secrets"
        "uid=1000"
        "gid=100"
      ];
    };
in
{
  imports = [
    ./hardware-configuration.nix
    ../../pkgs/ntnu-vpn
  ];

  # Nix
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  programs.nix-ld.enable = true;

  # Boot
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Networking
  networking = {
    hostName = "zenith";
    networkmanager.enable = true;
  };

  # Locale, time & console
  time.timeZone = "Europe/Oslo";
  console.keyMap = "no";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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
  };

  # File systems
  fileSystems = lib.listToAttrs (map mkShare shares);

  # Users
  users.users."osbe" = {
    isNormalUser = true;
    description = "Oscar Berge";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };

  # Security
  security = {
    sudo.wheelNeedsPassword = false;
    pam.services.waylock = { };
    polkit.enable = true; # Polkit daemon
    soteria.enable = true; # Polkit agent
    rtkit.enable = true;
  };

  # Desktop: Sway, login & session
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = [ ];
  };

  programs.dconf.enable = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --remember --remember-session --time --asterisks";
      user = "greeter";
    };
  };

  # Audio
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };

  # Hardware & input
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.power-profiles-daemon.enable = true;

  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "0001:0001:09b4e68d" ];
      settings.main."leftmeta+leftshift+f23" = "rightcontrol";
    };
  };

  # Gaming
  programs = {
    steam.enable = true;
    gamemode.enable = true;
    gamescope.enable = true;
  };

  # Services & virtualisation
  services.openssh.enable = true;
  virtualisation.docker.enable = true;
  programs.localsend.enable = true;

  # State version
  # Do NOT change this after the initial install. It does not affect which
  # nixpkgs version you're on; it only preserves compatibility with
  # stateful data. See `man configuration.nix` or
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.05";
}
