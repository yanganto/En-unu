{ config, lib, pkgs, ... }:
{
  hardware.opengl.driSupport32Bit = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.prime = {
    sync.enable = true;
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };
  hardware.nvidia.modesetting.enable = true;
}
