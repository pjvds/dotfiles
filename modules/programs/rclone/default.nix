{ config, lib, ... }:
let
  cfg = config.my.rclone;
  user = config.system.primaryUser;
in {
  options.my.rclone.enable = lib.mkEnableOption "rclone configuration";

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = { config, lib, pkgs, ... }: {
      # Native rclone binary. Docker (e.g. via OrbStack) can't be used here:
      # rclone's oauth callback server is hardcoded to bind 127.0.0.1 (not
      # configurable via flag or config - see rclone/rclone#469), and Docker's
      # port publishing can't reach a listener bound strictly to loopback.
      home.packages = [ pkgs.rclone ];
    };
  };
}
