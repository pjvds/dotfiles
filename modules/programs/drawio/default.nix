{ config, lib, ... }:
let
  cfg = config.my.drawio;
in
{
  options.my.drawio.enable = lib.mkEnableOption "draw.io Desktop";

  config = lib.mkIf cfg.enable {
    homebrew.casks = [ "drawio" ];
  };
}
