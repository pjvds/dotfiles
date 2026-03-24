{ pkgs, ... }: {
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
}
