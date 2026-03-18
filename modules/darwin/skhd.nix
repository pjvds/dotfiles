{ config, pkgs, lib, ... }: {
  # Disabled by default — AeroSpace is the active window manager.
  # Enable together with services.yabai when switching to Yabai.
  services.skhd.enable = false;
  services.skhd.package = pkgs.skhd;
}
