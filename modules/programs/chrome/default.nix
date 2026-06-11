{ lib, config, pkgs, ... }:
with lib;
let cfg = config.my.chrome; in
{
  options.my.chrome.enable = mkEnableOption "Google Chrome";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ google-chrome ];
  };
}
