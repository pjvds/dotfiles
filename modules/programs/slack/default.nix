{ config, lib, ... }:
let
  cfg = config.my.slack;
in {
  options.my.slack.enable = lib.mkEnableOption "Slack messaging app";

  config = lib.mkIf cfg.enable {
    homebrew.casks = [ "slack" ];

    # Slack reads enforced settings at the plist root, not under Defaults.
    home-manager.users.${config.system.primaryUser} = {
      targets.darwin.defaults."com.tinyspeck.slackmacgap".AutoUpdate = false;
    };
  };
}
