{ config, lib, ... }:
let
  cfg = config.my.karabiner;
  user = config.system.primaryUser;
  homeDir = "/Users/${user}";
in {
  options.my.karabiner.enable = lib.mkEnableOption "Karabiner keyboard configuration";

  config = lib.mkIf cfg.enable {
    homebrew.casks = [ "karabiner-elements" ];

    home-manager.users.${user} = { config, ... }: {
      home.file.".config/karabiner".source =
        config.lib.file.mkOutOfStoreSymlink "${homeDir}/dotfiles/modules/programs/karabiner/config";
    };
  };
}
