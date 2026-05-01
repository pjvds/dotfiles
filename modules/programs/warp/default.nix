{ config, lib, ... }:
let
  cfg = config.my.warp;
  user = config.system.primaryUser;
  homeDir = "/Users/${user}";
in {
  options.my.warp.enable = lib.mkEnableOption "Warp terminal";

  config = lib.mkIf cfg.enable {
    homebrew.casks = [ "warp" ];

    home-manager.users.${user} = { config, ... }: {
      home.file.".warp".source =
        config.lib.file.mkOutOfStoreSymlink "${homeDir}/dotfiles/modules/programs/warp/config";
    };
  };
}
