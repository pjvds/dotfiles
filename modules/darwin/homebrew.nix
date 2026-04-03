{ config, hostname, ... }: {
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

    # GUI Applications (Casks)
    casks = [
      "android-studio"
      "arc"
      "cursorcerer"
      "deckset"
      "lm-studio"
      "microsoft-azure-storage-explorer"
      "philips-hue-sync"
      "protonvpn"
      "qmk-toolbox"
      "sonos"
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

    brews = [
      "switchaudio-osx"
    ];

    masApps = {
      "Amphetamine" = 937984704;
    } // (if hostname == "Pieters-MacBook-Pro" then {
      "WhatsApp" = 310633997;
    } else {});
  };
}
