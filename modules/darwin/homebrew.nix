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
      "arc"
      "deckset"
      "lm-studio"
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
      { name = "pulumi/tap/pulumi"; }  # nixpkgs lacks the .NET language plugin
    ];

    masApps = {
      "Amphetamine" = 937984704;
    };
  };
}
