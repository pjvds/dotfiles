{ config, lib, pkgs, ... }:
let cfg = config.my.specKit; in
{
  options.my.specKit.enable = lib.mkEnableOption "Spec Kit - toolkit for Spec-Driven Development";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ spec-kit ];
  };
}
