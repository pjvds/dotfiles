{ config, lib, pkgs, ... }:
with lib;
let cfg = config.my.node; in
{
  options.my.node.enable = mkEnableOption "Node.js with fnm version manager";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ fnm ];

    home.file.".npmrc" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/dotfiles/modules/programs/node/config/.npmrc";
      force = true;
    };

    programs.zsh = {
      shellAliases = {
        sst = "bunx sst";
      };

      initContent = lib.mkOrder 105 ''
        # fnm (Fast Node Manager) — auto-switch Node versions
        eval "$(fnm env --use-on-cd)"
      '';
    };
  };
}
