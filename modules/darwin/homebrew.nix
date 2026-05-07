{ config, ... }: {
  homebrew = {
    enable = true;
    user = config.system.primaryUser;
    prefix = "/opt/homebrew";
    onActivation = {
      autoUpdate = true;
      cleanup = "zap"; # Removes unlisted formulas and casks
      upgrade = true;
    };

    taps = [
      "felixkratz/formulae"
      "nikitabobko/tap"
    ];

    # GUI Applications (Casks) - shared across all hosts
    casks = [
      "arc"
      "cursorcerer"
      "deckset"
      "lm-studio"
      "microsoft-azure-storage-explorer"
      "philips-hue-sync"
      "protonvpn"
      "proton-pass"
      "qmk-toolbox"
      "sonos"
      "zen"
      "zwift"
      
      # Fonts
      "font-blex-mono-nerd-font"
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

    brews = [
      "switchaudio-osx"
    ];

    masApps = {
      "Amphetamine" = 937984704;
      "WhatsApp" = 310633997;
    };
  };
}
