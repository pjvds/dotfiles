{ config, pkgs, lib, ... }: {
  imports = [
    ../modules/darwin/ui.nix
    ../modules/darwin/homebrew.nix
    ../modules/darwin/dictation.nix
  ];

  # Time Zone
  time.timeZone = "Europe/Amsterdam";


  # System packages
  environment.systemPackages = [ ];

  # Enable Touch ID for sudo (new syntax)
  security.pam.services.sudo_local.touchIdAuth = true;

  # Disable nix-darwin's management of the Nix installation
  # We use the Determinate Systems installer which sets up its own daemon.
  # If we leave this true, nix-darwin will throw an error: "Determinate detected, aborting activation"
  nix.enable = false;
  
  # Nix settings are also managed by the Determinate Systems daemon, 
  # so we comment these out to avoid confusion.
  # nix.settings = {
  #   experimental-features = "nix-command flakes";
  #   trusted-users = [ "@admin" ];
  # };

  # Set primary user for system defaults to apply correctly
  system.primaryUser = if config.networking.hostName == "Pieters-MacBook-Pro.local" then "pjvds" else "pvandesande";

  # macOS system defaults
  system.defaults = {
    # ... existing defaults ...
  };

  # Set system state version
  system.stateVersion = 5;

  # Disable documentation builds to speed up rebuilds
  documentation.enable = false;

  # User configuration
  users.users.pvandesande = {
    name = "pvandesande";
    home = "/Users/pvandesande";
  };

  users.users.pjvds = {
    name = "pjvds";
    home = "/Users/pjvds";
  };
}
