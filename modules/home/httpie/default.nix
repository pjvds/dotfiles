{ config, lib, ... }:
let cfg = config.my.httpie; in
{
  options.my.httpie.enable = lib.mkEnableOption "HTTPie configuration";

  config = lib.mkIf cfg.enable {
    home.file.".config/httpie".source =
      config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/dotfiles/modules/home/httpie/config";
  };
}
