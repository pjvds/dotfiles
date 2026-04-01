{ config, lib, ... }:
let cfg = config.my.ssh; in
{
  options.my.ssh.enable = lib.mkEnableOption "SSH configuration";

  config = lib.mkIf cfg.enable {
    home.file.".ssh/config".source =
      config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/dotfiles/ssh/config";
  };
}
