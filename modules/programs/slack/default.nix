{ config, lib, ... }:
let
  cfg = config.my.slack;
in {
  options.my.slack.enable = lib.mkEnableOption "Slack messaging app";

  config = lib.mkIf cfg.enable {
    homebrew.casks = [ "slack" ];
  };
}
