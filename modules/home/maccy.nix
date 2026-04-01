{ config, lib, pkgs, ... }:
let cfg = config.my.maccy; in
{
  options.my.maccy.enable = lib.mkEnableOption "Maccy clipboard manager launchd agent";

  config = lib.mkIf cfg.enable {
    # This creates a user-level launchd agent (~/Library/LaunchAgents/org.nixos.maccy.plist)
    launchd.agents.maccy = {
      enable = true;
      config = {
        ProgramArguments = [ "${pkgs.maccy}/Applications/Maccy.app/Contents/MacOS/Maccy" ];
        RunAtLoad = true;
        KeepAlive = false;
        ProcessType = "Interactive";
      };
    };
  };
}
