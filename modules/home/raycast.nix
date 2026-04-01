{ config, lib, pkgs, ... }:
let cfg = config.my.raycast; in
{
  options.my.raycast.enable = lib.mkEnableOption "Raycast launcher launchd agent";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.raycast ];

    # This creates a user-level launchd agent (~/Library/LaunchAgents/org.nixos.raycast.plist)
    launchd.agents.raycast = {
      enable = true;
      config = {
        ProgramArguments = [ "${pkgs.raycast}/Applications/Raycast.app/Contents/MacOS/Raycast" ];
        RunAtLoad = true;
        KeepAlive = false;
        ProcessType = "Interactive";
      };
    };
  };
}
