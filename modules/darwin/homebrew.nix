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

  system.activationScripts.postActivation.text = ''
    echo "Setting up Maccy login item..."
    osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Maccy.app", hidden:false}' 2>/dev/null || true
  '';
}
