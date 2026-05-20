{ config, lib, pkgs, ... }:
let cfg = config.my.shortcat; in
{
  options.my.shortcat.enable = lib.mkEnableOption "Shortcat keyboard-driven UI navigation";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.shortcat ];

    launchd.agents.shortcat = {
      enable = true;
      config = {
        ProgramArguments = [ "${pkgs.shortcat}/Applications/Shortcat.app/Contents/MacOS/Shortcat" ];
        RunAtLoad = true;
        KeepAlive = false;
        ProcessType = "Interactive";
      };
    };

    targets.darwin.defaults."com.sproutcube.Shortcat" = {
      # Hotkey to toggle Shortcat (Ctrl+Option+F)
      "KeyboardShortcuts_toggleShortcat" = "{\"carbonModifiers\":6144,\"carbonKeyCode\":3}";

      # Navigation keys (vim-style: h/j/k/l)
      leftKeycode  = 4;
      downKeycode  = 38;
      upKeycode    = 40;
      rightKeycode = 37;
    };
  };
}
