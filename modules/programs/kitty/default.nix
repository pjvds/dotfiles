{ config, lib, ... }:
let
  cfg = config.my.kitty;
  user = config.system.primaryUser;
  homeDir = "/Users/${user}";
in {
  options.my.kitty.enable = lib.mkEnableOption "kitty terminal";

  config = lib.mkIf cfg.enable {
    homebrew.casks = [ "kitty" ];

    home-manager.users.${user} = { config, ... }: {
      home.file.".config/kitty".source =
        config.lib.file.mkOutOfStoreSymlink "${homeDir}/dotfiles/modules/programs/kitty/config";

      programs.zsh.shellAliases = {
        icat = "kitty +kitten icat";
        ssh  = "kitty +kitten ssh";
      };
    };
  };
}
