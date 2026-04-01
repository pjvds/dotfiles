{ pkgs, config, lib, ... }:
let cfg = config.my.ncspot; in
{
  options.my.ncspot.enable = lib.mkEnableOption "ncspot Spotify TUI client";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.ncspot ];

    # Live-editable ncspot config without rebuild
    home.file.".config/ncspot".source =
      config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/dotfiles/ncspot";
  };
}
