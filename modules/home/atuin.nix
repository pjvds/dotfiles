{ pkgs, config, lib, ... }:
let cfg = config.my.atuin; in
{
  options.my.atuin.enable = lib.mkEnableOption "atuin shell history";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.atuin ];

    # Remove stale symlink left over from the old mkOutOfStoreSymlink setup.
    # Only removes the path if it is a symlink — never touches a real directory
    # (which would contain the sync key and auth token).
    home.activation.cleanAtuinSymlink = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
      if [ -L "${config.home.homeDirectory}/.config/atuin" ]; then
        rm "${config.home.homeDirectory}/.config/atuin"
      fi
    '';

    programs.atuin = {
      enable = true;
      enableZshIntegration = true;
      forceOverwriteSettings = true;
      settings = {
        style        = "full";
        enter_accept = true;
        sync.records = true;
      };
    };
  };
}
