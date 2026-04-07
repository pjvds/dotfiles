{ config, lib, ... }:
let
  cfg = config.my.obsidian;
  user = config.system.primaryUser;
  homeDir = "/Users/${user}";
in {
  options.my.obsidian.enable = lib.mkEnableOption "Obsidian note-taking app";

  config = lib.mkIf cfg.enable {
    homebrew.casks = [ "obsidian" ];

    home-manager.users.${user} = { config, ... }: {
      # Obsidian stores live state (vaults, window layout, plugin cache) here.
      home.file."Library/Application Support/obsidian".source =
        config.lib.file.mkOutOfStoreSymlink "${homeDir}/dotfiles/modules/programs/obsidian/config";
    };
  };
}
