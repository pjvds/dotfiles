{ config, lib, pkgs, ... }:
let
  cfg = config.my.gitify;
  user = config.system.primaryUser;
in {
  options.my.gitify.enable = lib.mkEnableOption "Gitify GitHub notifications";

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [ pkgs.gitify ];
    };
  };
}
