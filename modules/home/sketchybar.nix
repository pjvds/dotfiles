{ config, lib, ... }:
let cfg = config.my.sketchybar; in
{
  options.my.sketchybar.enable = lib.mkEnableOption "sketchybar configuration";

  config = lib.mkIf cfg.enable {
    home.file.".config/sketchybar".source =
      config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/dotfiles/sketchybar";
  };
}
