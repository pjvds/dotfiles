{ pkgs, config, lib, ... }:
let cfg = config.my.ncspot; in
{
  options.my.ncspot.enable = lib.mkEnableOption "ncspot Spotify TUI client";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.ncspot ];

    home.file.".config/ncspot".source =
      config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/dotfiles/modules/home/ncspot/config";
  };
}
