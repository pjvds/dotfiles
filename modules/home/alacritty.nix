{ config, lib, ... }:
let cfg = config.my.alacritty; in
{
  options.my.alacritty.enable = lib.mkEnableOption "alacritty terminal configuration";

  config = lib.mkIf cfg.enable {
    home.file.".config/alacritty".source =
      config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/dotfiles/alacritty";
  };
}
