{ config, lib, ... }:
let
  cfg = config.my.pgadmin;
in {
  options.my.pgadmin.enable = lib.mkEnableOption "pgAdmin PostgreSQL administration";

  config = lib.mkIf cfg.enable {
    homebrew.casks = [ "pgadmin4" ];
  };
}
