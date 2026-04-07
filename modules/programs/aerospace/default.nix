{ config, pkgs, lib, ... }:
let
  cfg = config.my.aerospace;
  user = config.system.primaryUser;
  homeDir = "/Users/${user}";
in {
  options.my.aerospace.enable = lib.mkEnableOption "AeroSpace window manager";

  config = lib.mkIf cfg.enable {
    services.aerospace.enable = true;

    launchd.user.agents.aerospace.serviceConfig.ProgramArguments = lib.mkForce [
      "/bin/sh"
      "-c"
      "PATH=/run/current-system/sw/bin:/usr/bin:/bin:/usr/sbin:/sbin /bin/wait4path /nix/store && exec ${pkgs.aerospace}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace --config-path ${homeDir}/.config/aerospace/aerospace.toml"
    ];

    home-manager.users.${user} = { config, ... }: {
      home.file.".config/aerospace".source =
        config.lib.file.mkOutOfStoreSymlink "${homeDir}/dotfiles/modules/programs/aerospace/config";
    };
  };
}
