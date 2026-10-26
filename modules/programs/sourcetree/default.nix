{ config, lib, ... }:
let
  cfg = config.my.sourcetree;
in
{
  options.my.sourcetree.enable = lib.mkEnableOption "Sourcetree";

  config = lib.mkIf cfg.enable {
    homebrew.casks = [ "sourcetree" ];

    home-manager.users.${config.system.primaryUser} = {
      targets.darwin.defaults."com.torusknot.SourceTreeNotMAS" = {
        SUEnableAutomaticChecks = false;
        SUAutomaticallyUpdate = false;
      };
    };
  };
}
