# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, nixvim, inputs, outputs, ... }:

{
  # Experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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
  hardware.nvidia = {
    modesetting.enable = true;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  #services.displayManager.defaultSession = "plasmax11";

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

# bluetooth
  hardware.bluetooth.enable = true;

  # Enable sound with pipewire.
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Groups
  users.groups.share = {
    name = "share";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ryan = {
    isNormalUser = true;
    description = "ryan";
    extraGroups = [ "networkmanager" "wheel" "docker" "share" ];
    packages = with pkgs; [
      telegram-desktop
      firefox
      kate
      obsidian
      bitwarden
      spotify
      discord
      runelite
      rpi-imager
      logseq
      steam
      gparted

      # Text editors
      helix
#      neovim
    ];
  };

  users.users.cam = {
    isNormalUser = true;
    description = "cam";
    extraGroups = [ "networkmanager" "wheel" "share" ];
    packages = with pkgs; [
      telegram-desktop
      firefox
      bitwarden
      spotify
      discord
      steam
      runelite
    ];
  };

  users.users.share = {
    isNormalUser = true;
    group = "users";
    description = "share";
    extraGroups = [ "networkmanager" "wheel" ];
    homeMode = "770";
    packages = with pkgs; [
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Allow insecure packages
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
    "electron-27.3.11"
  ];


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    pkgs.vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    pkgs.wget
    pkgs.git
    pkgs.libsForQt5.kalk
    pkgs.protonup-qt
    inputs.nixvim.legacyPackages.x86_64-linux.nixvim
    pkgs.devbox
];
environment.shellAliases = {
  vi = "nvim";
  vim = "nvim";
};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # List services that you want to enable:
  services.flatpak.enable = true;

  # Garbage Collection and Optimization
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  
  nix.optimise = {
    automatic = true;
    dates = [ "03:45" ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  programs.ssh.startAgent = true;

  # Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  services.dockerRegistry.openFirewall = true;

  # udev rules
  services.udev =  {
    enable = true;
    extraRules = 
    ''
      # Make an RP2040 in BOOTSEL mode writable by all users, so you can `picotool`
      # without `sudo`. 
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="0003", MODE="0666"

      #picoprobe
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2e8a", MODE="0666"

    '';
  };
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
  system.stateVersion = "24.05"; # Did you read the comment?

}

