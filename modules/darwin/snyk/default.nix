{ config, lib, ... }:
with lib;
let cfg = config.my.snyk; in
{
  options.my.snyk.enable = mkEnableOption "Snyk security scanner";

  config = mkIf cfg.enable {
    homebrew.brews = lib.mkAfter [ "snyk-cli" ];
  };
}

