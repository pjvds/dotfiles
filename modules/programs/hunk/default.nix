{ config, lib, pkgs, ... }:
let
  cfg = config.my.hunk;
in {
  options.my.hunk.enable = lib.mkEnableOption "Hunk terminal diff viewer";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.hunk ];

    home.file.".config/hunk/config.toml".source =
      config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/dotfiles/modules/programs/hunk/config/config.toml";
  };
}
