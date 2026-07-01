{ config, lib, ... }:
let
  cfg = config.my.mobile;
  user = config.system.primaryUser;
in {
  options.my.mobile.enable = lib.mkEnableOption "Mobile development (Flutter, iOS, Android)";

  config = lib.mkIf cfg.enable {
    # Flutter and CocoaPods are installed via Homebrew, not nixpkgs.
    # The Nix store is read-only which breaks iOS codesigning during `flutter run`.
    homebrew.casks = [ "flutter" ];
    homebrew.brews = [ "cocoapods" ];
    homebrew.masApps = { "Xcode" = 497799835; };

    home-manager.users.${user} = { ... }: {
      programs.zsh.initContent = ''
        if [ -d "$HOME/Library/Android/sdk" ]; then
          export ANDROID_HOME="$HOME/Library/Android/sdk"
          export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"
        fi
      '';
    };
  };
}
