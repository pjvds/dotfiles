{ lib, config, pkgs, ... }:
with lib;
let cfg = config.my.fonts; in
{
  options.my.fonts.enable = mkEnableOption "Font packages";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Core monospace fonts
      cascadia-code
      hasklig
      source-code-pro
      dejavu_fonts

      # Nerd fonts (provide all weights, variants, and icon glyphs)
      (nerd-fonts.fira-code)
      (nerd-fonts.hack)
      (nerd-fonts.sauce-code-pro)
      (nerd-fonts.dejavu-sans-mono)
      (nerd-fonts.ubuntu-mono)
      (nerd-fonts.droid-sans-mono)

      # Icon and symbol fonts
      font-awesome
      noto-fonts
      noto-fonts-color-emoji

      # Ubuntu classic font
      ubuntu-classic
    ];
  };
}
