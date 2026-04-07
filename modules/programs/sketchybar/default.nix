{ config, pkgs, lib, ... }:
let
  cfg = config.my.sketchybar;
  user = config.system.primaryUser;
  homeDir = "/Users/${user}";
in {
  options.my.sketchybar.enable = lib.mkEnableOption "SketchyBar status bar";

  config = lib.mkIf cfg.enable {
    services.sketchybar.enable = true;

    launchd.user.agents.sketchybar.serviceConfig.ProgramArguments = lib.mkForce [
      "/bin/sh"
      "-c"
      "PATH=/run/current-system/sw/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin exec ${pkgs.sketchybar}/bin/sketchybar"
    ];

    home-manager.users.${user} = { config, ... }: {
      home.file.".config/sketchybar".source =
        config.lib.file.mkOutOfStoreSymlink "${homeDir}/dotfiles/modules/programs/sketchybar/config";
    };
  };
}
