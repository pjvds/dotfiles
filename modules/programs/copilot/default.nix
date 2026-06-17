{ config, lib, ... }:
let
  cfg = config.my.copilot;
  user = config.system.primaryUser;
  homeDir = "/Users/${user}";
in {
  options.my.copilot.enable = lib.mkEnableOption "GitHub Copilot CLI";

  config = lib.mkIf cfg.enable {
    homebrew.casks = lib.mkAfter [ "copilot-cli" ];

    home-manager.users.${user} = { config, lib, ... }: {
      home.file.".copilot".source =
        config.lib.file.mkOutOfStoreSymlink "${homeDir}/dotfiles/modules/programs/copilot/config";

      home.activation.copilotSkillsSymlink = lib.hm.dag.entryAfter ["writeBoundary"] ''
        ln -sfn "${homeDir}/dotfiles/modules/ai/skills" \
          "${homeDir}/dotfiles/modules/programs/copilot/config/skills"
      '';

      programs.zsh.shellAliases = {
        c  = "copilot --add-dir /tmp --add-dir \"\$(pwd)\"";
        cp = "c -p "; # Execute a prompt in *non-interactive* mode, and print the result to stdout.
        ci = "c -i "; # Execute a prompt in *interactive* mode, and print the result to stdout.
      };
    };
  };
}
