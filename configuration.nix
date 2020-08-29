# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    ./interfaces.nix
    ../../Sekreto/networks.nix
  ];

  # TODO: handle efi grub parpmeter build
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # TODO: passing variable into host
  networking.hostName = "nixos"; 
  networking.wireless.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  time = {
    timeZone = "Asia/Taipei";
    hardwareClockInLocalTime = false;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    #TODO: package overlay
    #core
    wget neovim wpa_supplicant ripgrep

    #user
    sudo firefox git qtile alacritty rustup python3 zsh
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List services that you want to enable:

  # TODO: service overlay
  # services.openssh.enable = true;
  services.printing.enable = true;
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";
  services.xserver.libinput.enable = true;
  services.xserver.windowManager.qtile.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;



  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = "${pkgs.zsh}/bin/zsh";
  users.users.yanganto = {
    home = "/home/yanganto";
    isNormalUser = true;
    extraGroups = [ 
      "wheel"
      "networkmanager"
      "adbusers"
      "audio"
      "docker"
      "netdata"
      "networkmanager"
      "libvirtd"
      "vboxusers"
      "wheel"
    ];
  };

  # TODO: move on and keep OS rolling 
  system.stateVersion = "20.03"; 
}

