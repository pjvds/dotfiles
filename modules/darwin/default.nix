{ config, pkgs, lib, ... }: {
  imports = [
    ./homebrew.nix
    ./dictation.nix
    # Unified program modules (install + config in one place)
    ../programs/copilot
    ../programs/aerospace
    ../programs/sketchybar
    ../programs/borders
    ../programs/karabiner
    ../programs/kitty
    ../programs/obsidian
    ../programs/warp
    ../programs/slack
    ./snyk
    ./lazyworktree
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "proton-pass-cli"
    "android-studio"
    "discord"
    "idea"
    "obsidian"
    "raycast"
    "rider"
    "shortcat"
    "shottr"
    "vscode"
  ];

  my.copilot.enable    = true;
  my.aerospace.enable  = true;
  my.sketchybar.enable = true;
  my.borders.enable    = true;
  my.karabiner.enable  = true;
  my.kitty.enable      = true;
  my.obsidian.enable   = true;
  my.snyk.enable       = true;
  my.slack.enable      = true;

  # Time Zone
  time.timeZone = "Europe/Amsterdam";

  # Enable Touch ID for sudo (new syntax)
  security.pam.services.sudo_local.touchIdAuth = true;

  # Allow passwordless sudo for kanata (keyboard remapper)
  security.sudo.extraConfig = ''
    ${config.system.primaryUser} ALL=(ALL) NOPASSWD: ${pkgs.kanata-with-cmd}/bin/kanata
  '';

  # Disable nix-darwin's management of the Nix installation
  nix.enable = false;

  # macOS system defaults
  system.defaults = {
    # Dock (Application Bar)
    dock = {
      autohide = true;
      tilesize = 16;
      show-recents = false;
      magnification = true;
      largesize = 64;
    };

    # Finder
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "Nlsv";
      ShowPathbar = true;
      FXDefaultSearchScope = "SCcf";
      FXEnableExtensionChangeWarning = false;
      _FXSortFoldersFirst = true;
    };

    # Global macOS settings
    NSGlobalDomain = {
      _HIHideMenuBar = true;
      ApplePressAndHoldEnabled = false;
      AppleInterfaceStyle = "Dark";
    };

    # Trackpad
    trackpad = {
      Clicking = true;
    };
  };

  # Accept Xcode license automatically (runs as root during activation)
  system.activationScripts.xcodeAcceptLicense.text = ''
    if /usr/bin/xcodebuild -license check 2>/dev/null | /usr/bin/grep -q "not yet accepted"; then
      /usr/bin/xcodebuild -license accept
    fi
  '';

  # Set system state version
  system.stateVersion = 5;

  # Disable documentation builds to speed up rebuilds
  documentation.enable = false;

  # Set environment variables for GUI applications and login shells
  environment.extraInit = ''
    # Make Homebrew packages available to all applications
    if [ -x "/opt/homebrew/bin/brew" ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  '';
}
