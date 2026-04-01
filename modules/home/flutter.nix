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
  };
}
