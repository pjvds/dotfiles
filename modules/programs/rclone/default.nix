{ config, lib, ... }:
let
  cfg = config.my.rclone;
  user = config.system.primaryUser;
in {
  options.my.rclone.enable = lib.mkEnableOption "rclone configuration";

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = { config, lib, pkgs, ... }: {
      # Native rclone binary. Needed because rclone's oauth callback server is
      # hardcoded to bind 127.0.0.1, which is unreachable from the Mac browser
      # when run inside a docker container (e.g. via OrbStack).
      home.packages = [ pkgs.rclone ];
    };
  };
}
