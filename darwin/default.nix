{ config, pkgs, lib, hostname, ... }: {
  imports = [
    ../modules/darwin/homebrew.nix
    ../modules/darwin/dictation.nix
    # Per-app modules (each owns its service + launchd config)
    ../modules/darwin/aerospace.nix
    ../modules/darwin/sketchybar.nix
    ../modules/darwin/borders.nix
    ../modules/darwin/karabiner.nix
    ../modules/darwin/kitty.nix
    ../modules/darwin/yabai.nix
    ../modules/darwin/skhd.nix
  ];

  # Networking
  networking.hostName = hostname;

  # Time Zone
  time.timeZone = "Europe/Amsterdam";

  # System packages
  environment.systemPackages = [ 
    pkgs.home-manager
  ];

  # Enable Touch ID for sudo (new syntax)
  security.pam.services.sudo_local.touchIdAuth = true;

  # Disable nix-darwin's management of the Nix installation
  nix.enable = false;
  
  # Set primary user for system defaults to apply correctly
  system.primaryUser = if hostname == "Pieters-MacBook-Pro" then "pjvds" else "pvandesande";

  # macOS system defaults
  system.defaults = {
    # Dock (Application Bar)
    dock = {
      autohide = true;
      tilesize = 16;
      show-recents = false;
      magnification = true;
      largesize = 64;  # Magnified icon size
    };

    # Finder
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "Nlsv";  # List view
      ShowPathbar = true;
      FXDefaultSearchScope = "SCcf";  # Search current folder by default
      FXEnableExtensionChangeWarning = false;  # Disable extension change warning
      _FXSortFoldersFirst = true;
    };

    # Global macOS settings
    NSGlobalDomain = {
      # Menu Bar (Top Bar)
      _HIHideMenuBar = true;
      
      # Keyboard - Enable key repeat for Vim
      ApplePressAndHoldEnabled = false;
      
      # Appearance
      AppleInterfaceStyle = "Dark";  # Force Dark Mode
    };

    # Trackpad
    trackpad = {
      Clicking = true;  # Tap to click
    };
  };

  # Set system state version
  system.stateVersion = 5;

  # Disable documentation builds to speed up rebuilds
  documentation.enable = false;

  # User configuration (only create the relevant user for the machine)
  users.users = if hostname == "Pieters-MacBook-Pro" then {
    pjvds = {
      name = "pjvds";
      home = "/Users/pjvds";
    };
  } else {
    pvandesande = {
      name = "pvandesande";
      home = "/Users/pvandesande";
    };
  };
}
