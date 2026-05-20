{ config, lib, ... }:
let
  cfg = config.my.cursorcerer;
  user = config.system.primaryUser;
in {
  options.my.cursorcerer.enable = lib.mkEnableOption "Cursorcerer cursor hider";

  config = lib.mkIf cfg.enable {
    homebrew.casks = [ "cursorcerer" ];

    home-manager.users.${user} = {
      targets.darwin.defaults."com.doomlaser.cursorcerer" = {
        # Hotkey to toggle cursor visibility (Ctrl+Option+K)
        toggleCursorHotKey = {
          keyCode = 40;
          modifiers = 6144;
        };
        autoShow = 1;
        idleHide = "4.644531";
      };
    };
  };
}
