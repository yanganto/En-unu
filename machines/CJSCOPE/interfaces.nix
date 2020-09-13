{ config, lib, pkgs, ... }:
{
  networking.interfaces.enp6s0f1.useDHCP = true;
  networking.interfaces.wlp7s0.useDHCP = true;
}
