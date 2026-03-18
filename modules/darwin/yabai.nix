{ pkgs, ... }: {
  # Disabled by default — AeroSpace is the active window manager.
  # To try Yabai: set enable = true, disable AeroSpace service, then rebuild.
  services.yabai.enable = false;
  services.yabai.package = pkgs.yabai;
  # Config is loaded from ~/.config/yabai/yabairc via the symlink in
  # modules/home/yabai.nix — no extraConfig needed here.
}
