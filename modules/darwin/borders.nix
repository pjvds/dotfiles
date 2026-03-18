{ config, lib, ... }: {
  services.jankyborders.enable = true;

  # Use dotfiles bordersrc instead of default config
  launchd.user.agents.jankyborders.serviceConfig.ProgramArguments = lib.mkForce [
    "/bin/sh"
    "-c"
    "PATH=/run/current-system/sw/bin:/usr/bin:/bin:/usr/sbin:/sbin exec /Users/${config.system.primaryUser}/.config/borders/bordersrc"
  ];
}
