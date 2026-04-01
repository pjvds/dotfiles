{ pkgs, config, lib, ... }:
let cfg = config.my.atuin; in
{
  options.my.atuin.enable = lib.mkEnableOption "atuin shell history";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.atuin ];

    # Clean up any existing atuin config directory (from old mkOutOfStoreSymlink
    # setup, dangling GC'd store paths, or failed initialization).
    # Without this, atuin fails with "File exists (os error 17)".
    home.activation.cleanAtuinSymlink = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
      rm -rf "${config.home.homeDirectory}/.config/atuin"
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
