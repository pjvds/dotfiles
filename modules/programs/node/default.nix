{ config, lib, pkgs, ... }:
with lib;
let cfg = config.my.node; in
{
  options.my.node.enable = mkEnableOption "Node.js with fnm version manager";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ fnm ];

    programs.fnm.enable = true;
    programs.fnm.cacheEnvVars = true;

    home.file.".npmrc".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/modules/programs/node/config/.npmrc";

    programs.zsh.shellAliases = {
      sst = "bunx sst";
    };
  };
}
