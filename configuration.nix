{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports = [ 
    ./hardware-configuration.nix
    ./interfaces.nix
    ./video-card.nix
    ./hypervisor.nix
    ../../Sekreto/networks.nix
    ../../Sekreto/vpn.nix
  ];
  environment.systemPackages = with pkgs; [
    #TODO: package overlay

    # Core
    wget neovim wpa_supplicant ripgrep zsh oh-my-zsh busybox
    enlightenment.terminology pciutils usbutils

    # User
    ## Cli
    sudo exa fd nushell neo-cowsay bat busybox openconnect

    ## Desktop
    usbutils pciutils python3 qtile xdotool leafpad pcmanfm 
    # TODO: uncomment this when the PR merged
    # https://github.com/NixOS/nixpkgs/pull/100002
    alacritty pamixer # find-cursor
    firefox chromium thunderbird 
    # TODO: Porting ibus-array for nixOS
    hime # ibus ibus-engines.array
    tdesktop zoom-us discord
    texlive.combined.scheme-full libreoffice kate 
    trezord trezor_agent

    # Developer
    ## Linux develop
    autoconf automake binutils bison fakeroot file findutils flex gawk gcc 
    gettext groff libtool gnum4 gnustep.make gnupatch pkgconf texinfo 
    pkg-config openssl protobuf direnv universal-ctags
    # TODO: uncomment this officially release
    git # gitui 
    ## Rust develop
    rust-analyzer rustup sccache

    ## Python develop
    pypi2nix python38Packages.python-language-server

    ## Cloud develop
    kind docker kubectl

    ## Nix package develop
    nixpkgs-fmt
  ];

  fileSystems."/home/yanganto/data" = {
    # machine specific
    device = "/dev/disk/by-uuid/a0c969a0-54ff-4955-b175-eef80d727ce6";
    fsType = "ext4";
    options = [ "rw,noatime,nodiratime,discard,errors=remount-ro" ];
  };

  # TODO: handle efi grub parpmeter build
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmpOnTmpfs = true;

  # TODO: passing variable into host
  networking.hostName = "nixos"; 
  networking.wireless.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;


  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "hime";
      # enabled = "ibus"; 
      # ibus.engines = with pkgs.ibus-engines; [ table ];
    };
  };
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  time = {
    timeZone = "Asia/Taipei";
    hardwareClockInLocalTime = false;
  };
  # TODO: font overlay
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fontconfig = {
      enable = true;
      includeUserConf = true;
      defaultFonts = {
        monospace = [
          "WenQuanYi Micro Hei Mono"
          "文泉驛等寬微米黑"
          "Noto Sans Mono CJK TC"
        ];

        sansSerif = [
          "WenQuanYi Micro Hei"
          "文泉驛微米黑"
          "Noto Sans CJK TC"
        ];

        serif = [
          "WenQuanYi Micro Hei"
          "文泉驛微米黑"
          "Noto Sans CJK TC"
        ];
      };
    };

    fonts = with pkgs; [
      iosevka inconsolata unifont
      terminus_font terminus_font_ttf
      anonymousPro source-code-pro meslo-lg
      wqy_microhei wqy_zenhei
      fira fira-code fira-mono
      noto-fonts noto-fonts-cjk
      siji font-awesome-ttf
      powerline-fonts
    ];
  };

  programs.zsh.enable = true;
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" "sudo" ];
  };
  programs.light.enable = true;

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


  # TODO User overlay 
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

  # develop settings
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = false;
      liveRestore = false;
      package = pkgs.docker-edge;
    };
  };

  # TODO: move on unstable and keep NixOS rolling 
  system.stateVersion = "20.03"; 

  # Nix Community
  # nix-envdir
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';
  environment.pathsToLink = [
    "/share/nix-direnv"
  ];
}

