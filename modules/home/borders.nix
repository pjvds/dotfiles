{ config, lib, ... }:
let cfg = config.my.borders; in
{
  options.my.borders.enable = lib.mkEnableOption "borders window decorator configuration";

  config = lib.mkIf cfg.enable {
    home.file.".config/borders".source =
      config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/dotfiles/borders";
  };
}
