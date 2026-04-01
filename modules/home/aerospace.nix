{ config, lib, ... }:
let cfg = config.my.aerospace; in
{
  options.my.aerospace.enable = lib.mkEnableOption "aerospace window manager configuration";

  config = lib.mkIf cfg.enable {
    home.file.".config/aerospace".source =
      config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/dotfiles/aerospace";
  };
}
