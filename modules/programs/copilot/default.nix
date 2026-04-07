{ config, lib, ... }:
let
  cfg = config.my.copilot;
  user = config.system.primaryUser;
  homeDir = "/Users/${user}";
in {
  options.my.copilot.enable = lib.mkEnableOption "GitHub Copilot CLI";

  config = lib.mkIf cfg.enable {
    homebrew.casks = lib.mkAfter [ "copilot-cli" ];

    home-manager.users.${user} = { config, ... }: {
      home.file.".copilot".source =
        config.lib.file.mkOutOfStoreSymlink "${homeDir}/dotfiles/modules/programs/copilot/config";

      programs.zsh.shellAliases = {
        c  = "copilot";
        cp = "c -p ";
      };
    };
  };
}
