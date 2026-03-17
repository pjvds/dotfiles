{ config, pkgs, lib, ... }: {
  # Window Management Services
  services.aerospace.enable = true;
  services.sketchybar.enable = true;
  services.jankyborders.enable = true;

  # Ensure AeroSpace uses our dotfiles configuration
  launchd.user.agents.aerospace.serviceConfig.ProgramArguments = lib.mkForce [
    "/bin/sh"
    "-c"
    "PATH=/run/current-system/sw/bin:/usr/bin:/bin:/usr/sbin:/sbin /bin/wait4path /nix/store && exec ${pkgs.aerospace}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace --config-path /Users/${config.system.primaryUser}/.config/aerospace/aerospace.toml"
  ];

  # Ensure JankyBorders uses our dotfiles configuration
  launchd.user.agents.jankyborders.serviceConfig.ProgramArguments = lib.mkForce [
    "/bin/sh"
    "-c"
    "PATH=/run/current-system/sw/bin:/usr/bin:/bin:/usr/sbin:/sbin exec /Users/${config.system.primaryUser}/.config/borders/bordersrc"
  ];

  # Ensure SketchyBar has the correct PATH to find aerospace, jq and SwitchAudioSource
  launchd.user.agents.sketchybar.serviceConfig.ProgramArguments = lib.mkForce [
    "/bin/sh"
    "-c"
    "PATH=/run/current-system/sw/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin exec ${pkgs.sketchybar}/bin/sketchybar"
  ];
}
