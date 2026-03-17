{ ... }: {
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
      "alt-tab"
      "android-studio"
      "arc"
      "aws-vault-binary"
      "cursorcerer"
      "cyberduck"
      "deckset"
      "discord"
      "github"
      "intellij-idea"
      "karabiner-elements"
      "kitty"
      "lm-studio"
      "maccy"
      "microsoft-azure-storage-explorer"
      "microsoft-edge"
      "obsidian"
      "philips-hue-sync"
      "proton-mail"
      "proton-pass"
      "protonvpn"
      "qmk-toolbox"
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

    brews = [
      "switchaudio-osx"
    ];
  };
}
