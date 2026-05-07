{ pkgs, lib, config, ... }:
let cfg = config.my.flutter; in
{
  options.my.flutter.enable = lib.mkEnableOption "Flutter SDK + Dart + CocoaPods";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      flutter
      cocoapods
    ];

    home.sessionVariables = {
      FLUTTER_ROOT = "${pkgs.flutter}";
    };

    home.activation.disableFlutterAnalytics = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD ${pkgs.flutter}/bin/flutter --disable-analytics
    '';

    programs.zsh.initContent = ''
      if [ -d "$HOME/Library/Android/sdk" ]; then
        export ANDROID_HOME="$HOME/Library/Android/sdk"
        export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"
      fi
    '';
  };
}
