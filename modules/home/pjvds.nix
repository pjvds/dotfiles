{ pkgs, ... }: {
  home.packages = with pkgs; [
    discord
  ];

  my.flutter.enable = true;
}
