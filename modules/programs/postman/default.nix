{ config, lib, ... }:
let
  cfg = config.my.postman;
in {
  options.my.postman.enable = lib.mkEnableOption "Postman API client";

  config = lib.mkIf cfg.enable {
    homebrew.casks = [ "postman" ];
  };
}
