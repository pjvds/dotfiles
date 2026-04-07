{ config, lib, ... }:
let
  cfg = config.my.borders;
  user = config.system.primaryUser;
  homeDir = "/Users/${user}";
in {
  options.my.borders.enable = lib.mkEnableOption "JankyBorders window decorator";

  config = lib.mkIf cfg.enable {
    services.jankyborders.enable = true;

    launchd.user.agents.jankyborders.serviceConfig.ProgramArguments = lib.mkForce [
      "/bin/sh"
      "-c"
      "PATH=/run/current-system/sw/bin:/usr/bin:/bin:/usr/sbin:/sbin exec ${homeDir}/.config/borders/bordersrc"
    ];

    home-manager.users.${user} = { config, ... }: {
      home.file.".config/borders".source =
        config.lib.file.mkOutOfStoreSymlink "${homeDir}/dotfiles/modules/programs/borders/config";
    };
  };
}
