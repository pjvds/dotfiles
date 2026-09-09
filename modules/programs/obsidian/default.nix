{ config, lib, ... }:
let
  cfg = config.my.obsidian;
  user = config.system.primaryUser;
  homeDir = "/Users/${user}";
in {
  options.my.obsidian = {
    enable = lib.mkEnableOption "Obsidian note-taking app";

    vaultPath = lib.mkOption {
      type = lib.types.str;
      default = "${homeDir}/Documents/personal";
      description = "Path to the main Obsidian vault whose plugin settings should be nix-managed.";
    };

    taskPresets = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        links_to_this = ''
          filter by function task.description.includes("[[" + query.file.filenameWithoutExtension + "]]") || task.description.includes("[[" + query.file.filenameWithoutExtension + "|")'';
      };
      description = ''
        Presets to declaratively merge into the Tasks plugin's data.json on every
        rebuild, so they survive vault/plugin data loss. Existing presets not
        listed here are left untouched.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    homebrew.casks = [ "obsidian" ];

    home-manager.users.${user} = { config, lib, pkgs, ... }: {
      # Obsidian stores live state (vaults, window layout, plugin cache) here.
      home.file."Library/Application Support/obsidian".source =
        config.lib.file.mkOutOfStoreSymlink "${homeDir}/dotfiles/modules/programs/obsidian/config";

      # Merge nix-managed Tasks plugin presets into the vault's data.json without
      # clobbering other user-editable settings (statuses, global filters, etc.).
      home.activation.obsidianTaskPresets =
        let
          dataJson = "${cfg.vaultPath}/.obsidian/plugins/obsidian-tasks-plugin/data.json";
          presetsJson = builtins.toJSON cfg.taskPresets;
        in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          if [ -f "${dataJson}" ]; then
            ${pkgs.jq}/bin/jq --argjson presets '${presetsJson}' \
              '.presets = (.presets // {}) * $presets' \
              "${dataJson}" > "${dataJson}.tmp" && mv "${dataJson}.tmp" "${dataJson}"
          fi
        '';
    };
  };
}
