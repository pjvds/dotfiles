{ config, pkgs, lib, ... }: {
  services.sketchybar.enable = true;

  # Ensure SketchyBar has the correct PATH to find aerospace, jq and SwitchAudioSource
  launchd.user.agents.sketchybar.serviceConfig.ProgramArguments = lib.mkForce [
    "/bin/sh"
    "-c"
    "PATH=/run/current-system/sw/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin exec ${pkgs.sketchybar}/bin/sketchybar"
  ];
}
