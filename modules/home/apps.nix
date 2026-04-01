{ pkgs, lib, config, ... }:
let cfg = config.my.apps; in
{
  options.my.apps.enable = lib.mkEnableOption "GUI applications";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      alt-tab-macos
      aws-vault
      cyberduck
      jetbrains.idea
      maccy
      protonmail-desktop
      proton-pass
      raycast
      jetbrains.rider
      shortcat
      shottr
      vscode
    ];
  };
}
