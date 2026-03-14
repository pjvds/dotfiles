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

  # Enable Homebrew management
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap"; # Removes unlisted formulas and casks
      upgrade = true;
    };

    taps = [
      "felixkratz/formulae"
      "nikitabobko/tap"
    ];

    # GUI Applications (Casks)
    casks = [
      "adobe-acrobat-reader"
      "aerospace"
      "alt-tab"
      "android-studio"
      "arc"
      "aws-vault-binary"
      "beekeeper-studio"
      "brave-browser"
      "caffeine"
      "commander-one"
      "cursorcerer"
      "cyberduck"
      "datagrip"
      "deckset"
      "discord"
      "evernote"
      "firefox"
      "forklift"
      "ghostty"
      "github"
      "google-chrome"
      "hiddenbar"
      "intellij-idea"
      "iterm2"
      "keepingyouawake"
      "kitty"
      "lm-studio"
      "maccy"
      "menumeters"
      "microsoft-azure-storage-explorer"
      "microsoft-edge"
      "obs"
      "obsidian"
      "philips-hue-sync"
      "proton-mail"
      "proton-pass"
      "protonvpn"
      "qmk-toolbox"
      "qutebrowser"
      "raycast"
      "rider"
      "shortcat"
      "shottr"
      "sonos"
      "visual-studio-code"
      "zen"
      "zwift"
      
      # Fonts
      "font-fira-code-nerd-font"
      "font-hack-nerd-font"
      "font-inconsolata"
      "font-iosevka-nerd-font"
      "font-jetbrains-mono-nerd-font"
      "font-monaspace"
      "font-monaspice-nerd-font"
      "font-sf-pro"
      "font-sketchybar-app-font"
    ];
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
