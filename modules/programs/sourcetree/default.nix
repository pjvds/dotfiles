{ config, lib, ... }:
let
  cfg = config.my.sourcetree;
in
{
  options.my.sourcetree.enable = lib.mkEnableOption "Sourcetree";

  config = lib.mkIf cfg.enable {
    homebrew.casks = [ "sourcetree" ];
  };
}
