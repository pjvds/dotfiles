{ config, lib, ... }:
let
  cfg = config.my.supernote;
in {
  options.my.supernote.enable = lib.mkEnableOption "Supernote Partner desktop app";

  config = lib.mkIf cfg.enable {
    # Supernote Partner (companion app for Supernote e-ink devices: note/document
    # sync, keyboard sharing) is Mac App Store-only, no Homebrew cask exists.
    # https://support.supernote.com/en_US/Tools-Features/supernote-partner-app-for-desktop
    homebrew.masApps = { "Supernote Partner" = 1494992020; };
  };
}
