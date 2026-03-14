{ config, pkgs, ... }: {
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
  system.primaryUser = "pvandesande";

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

  # User configuration
  users.users.pvandesande = {
    name = "pvandesande";
    home = "/Users/pvandesande";
  };
}
