{ config, ... }: {
  homebrew = {
    enable = true;
    user = config.system.primaryUser;
    prefix = "/opt/homebrew";
    onActivation = {
      autoUpdate = true;
      cleanup = "none"; # brew bundle --cleanup now requires --force; manage cleanup manually
      upgrade = true;
    };

    taps = [
      "felixkratz/formulae"
      "nikitabobko/tap"
    ];

    # GUI Applications (Casks) - shared across all hosts
    casks = [
      "adobe-acrobat-reader"
      # github-copilot CLI is managed via the copilot program module (cask: copilot-cli)
      # flutter is managed via the mobile module
      "arc"
      "deckset"
      "microsoft-azure-storage-explorer"
      "philips-hue-sync"
      "protonvpn"
      "proton-pass"
      "qmk-toolbox"
      "sonos"
      "zen"
      
      # Fonts — only those not available via nixpkgs nerd-fonts
      "font-sf-pro"
      "font-sketchybar-app-font"
    ];

    brews = [
      "switchaudio-osx"
      # cocoapods is managed via the mobile module
      { name = "pulumi/tap/pulumi"; }  # nixpkgs lacks the .NET language plugin
    ];

    masApps = {
      "Amphetamine" = 937984704;
      # Xcode is managed via the mobile module
    };
  };
}
