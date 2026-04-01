{ pkgs, ... }: {
  home.packages = with pkgs; [
    android-studio
    discord
  ];

  my.flutter.enable = true;
}
