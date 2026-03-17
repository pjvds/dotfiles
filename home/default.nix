{ config, pkgs, ... }: {
  imports = [
    ../modules/home/core.nix
    ../modules/home/languages.nix
    ../modules/home/cloud-k8s.nix
    ../modules/home/zsh.nix
    ../modules/home/git.nix
    ../modules/home/opencode.nix
    ../modules/home/ui-config.nix
    ../modules/home/editor.nix
    ../modules/home/terminal.nix
    ../modules/home/maccy.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should manage
  home = {
    username = "pvandesande";
    homeDirectory = "/Users/pvandesande";
    stateVersion = "24.11";
    
    # Packages to install
    packages = with pkgs; [
      opencode
    ];
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Disable manual/documentation generation to speed up rebuilds
  manual.manpages.enable = false;
  manual.html.enable = false;
  manual.json.enable = false;
}
