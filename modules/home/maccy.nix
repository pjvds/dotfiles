{ config, lib, pkgs, ... }: {
  # This creates a user-level launchd agent (~/Library/LaunchAgents/org.nixos.maccy.plist)
  launchd.agents.maccy = {
    enable = true;
    config = {
      ProgramArguments = [ "/Applications/Maccy.app/Contents/MacOS/Maccy" ];
      RunAtLoad = true;
      KeepAlive = false;
      ProcessType = "Interactive";
    };
  };
}
