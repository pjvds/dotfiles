{ config, lib, ... }:
let
  cfg = config.my.drawio;
in
{
  options.my.drawio.enable = lib.mkEnableOption "draw.io Desktop";

  config = lib.mkIf cfg.enable {
    homebrew.casks = [ "drawio" ];

    # Finder/Dock launches do not inherit shell environment variables.
    launchd.user.envVariables.DRAWIO_DISABLE_UPDATE = "true";
  };
}
