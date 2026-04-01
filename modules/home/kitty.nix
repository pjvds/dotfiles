{ config, lib, ... }:
let cfg = config.my.kitty; in
{
  options.my.kitty.enable = lib.mkEnableOption "kitty terminal configuration";

  config = lib.mkIf cfg.enable {
    home.file.".config/kitty".source =
      config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/dotfiles/kitty";
  };
}
