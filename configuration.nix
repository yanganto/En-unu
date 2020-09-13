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
  nixpkgs.config.allowUnfree = true;

  # TODO: handle efi grub parpmeter build
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmpOnTmpfs = true;

  # TODO: passing variable into host
  networking.hostName = "nixos"; 
  networking.wireless.enable = true;

  nixpkgs.config.packageOverrides = pkgs: {
    my_fcitx_array = pkgs.callPackage /home/yanganto/.config/nixpkgs/fcitx-array/default.nix {};
  };


  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "fcitx";
      fcitx.engines = with pkgs.fcitx-engines; [
        chewing 
        (
          table-extra.overrideAttrs ( 
            _: {
              src = pkgs.fetchFromGitHub {
                owner = "yanganto";
                repo = "fcitx-table-extra";
                rev = "3e60bf7118d3db8cb2c3e2b99e69395081f9d10e";
                sha256 = "1qz6vhxjm2isjmpc8nplp559ab84z9lkzx2aw2z7f3m6x8v1fybh";
              };
            } 
          )
        )
      ];
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
  fonts = {
    enableFontDir = true;
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
      iosevka
      inconsolata
      unifont

      terminus_font
      terminus_font_ttf

      anonymousPro
      source-code-pro
      meslo-lg

      wqy_microhei
      wqy_zenhei

      fira
      fira-code
      fira-mono

      noto-fonts
      noto-fonts-cjk

      siji
      font-awesome-ttf

      powerline-fonts
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #TODO: package overlay
    #core
    wget neovim wpa_supplicant ripgrep zsh oh-my-zsh busybox

    #user
    sudo firefox git qtile alacritty rustup python3 nushell neo-cowsay
    fcitx fcitx-engines.chewing fcitx-engines.table-extra
    pamixer 

    #develop
    autoconf automake binutils bison fakeroot file findutils flex gawk gcc 
    gettext groff libtool gnum4 gnustep.make gnupatch pkgconf texinfo 
    pkg-config openssl gitAndTools.gitui gitAndTools.tig envdir fzf
    universal-ctags

    libvirt minikube kind docker kubectl
  ];
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = false;
      liveRestore = false;
      package = pkgs.docker-edge;
    };
  };

  fileSystems."/home/yanganto/data" = {
    device = "/dev/disk/by-uuid/a0c969a0-54ff-4955-b175-eef80d727ce6";
    fsType = "ext4";
    options = [ "rw,noatime,nodiratime,discard,errors=remount-ro" ];
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

  # handle video overlay
  services.xserver.videoDrivers = [ "nvidia" ];

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
      "libvirtd"
      "vboxusers"
    ];
  };

  # TODO: move on and keep OS rolling 
  system.stateVersion = "20.03"; 
}

