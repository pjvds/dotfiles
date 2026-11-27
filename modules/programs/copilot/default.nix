{ config, lib, pkgs, ... }:
let
  cfg = config.my.copilot;
  user = config.system.primaryUser;
  homeDir = "/Users/${user}";
  axonSkills = builtins.fetchGit {
    url = "https://github.com/AxonIQ/agent-skills.git";
    ref = "main";
    rev = "59e7beb6bb487894aeb1294918463af1432bdece";
  };
  copilotSkills = pkgs.linkFarm "copilot-skills" (
    map (name: {
      inherit name;
      path = "${homeDir}/dotfiles/modules/ai/skills/${name}";
    }) (builtins.attrNames (builtins.readDir ../../ai/skills))
    ++ [{
      name = "axoniq-app-dev";
      path = "${axonSkills}/plugins/axoniq-app-development/skills/axoniq-app-dev";
    }]
  );
in {
  options.my.copilot.enable = lib.mkEnableOption "GitHub Copilot CLI";

  config = lib.mkIf cfg.enable {
    homebrew.casks = lib.mkAfter [ "copilot-cli" ];

    home-manager.users.${user} = { config, lib, ... }: {
      home.file.".copilot".source =
        config.lib.file.mkOutOfStoreSymlink "${homeDir}/dotfiles/modules/programs/copilot/config";

      home.activation.copilotSkillsSymlink = lib.hm.dag.entryAfter ["writeBoundary"] ''
        ln -sfn "${copilotSkills}" \
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
