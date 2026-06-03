{ lib, config, pkgs, ... }:
let cfg = config.my.asciinema; in
{
  options.my.asciinema.enable = lib.mkEnableOption "asciinema terminal recorder";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.asciinema ];
  };
}
