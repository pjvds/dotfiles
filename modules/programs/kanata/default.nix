{ lib, config, pkgs, ... }:
with lib;
let cfg = config.my.kanata; in
{
  options.my.kanata = {
    enable = mkEnableOption "Kanata keyboard remapper";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ kanata-with-cmd ];

    home.file.".config/kanata/kanata.kbd".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/modules/programs/kanata/config/kanata.kbd";
  };
}
