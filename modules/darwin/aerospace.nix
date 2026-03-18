{ config, pkgs, lib, ... }: {
  services.aerospace.enable = true;

  # Use dotfiles config path instead of the Nix store path
  launchd.user.agents.aerospace.serviceConfig.ProgramArguments = lib.mkForce [
    "/bin/sh"
    "-c"
    "PATH=/run/current-system/sw/bin:/usr/bin:/bin:/usr/sbin:/sbin /bin/wait4path /nix/store && exec ${pkgs.aerospace}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace --config-path /Users/${config.system.primaryUser}/.config/aerospace/aerospace.toml"
  ];
}
