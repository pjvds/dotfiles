{ config, pkgs, ... }: {
  imports = [
    ../modules/home/core.nix
    ../modules/home/languages.nix
    ../modules/home/cloud-k8s.nix
    ../modules/home/zsh.nix
    ../modules/home/git.nix
    ../modules/home/opencode.nix
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

    file.".config/sketchybar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/sketchybar";
    file.".config/aerospace".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/aerospace";
    file.".config/borders".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/borders";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Disable manual/documentation generation to speed up rebuilds
  manual.manpages.enable = false;
  manual.html.enable = false;
  manual.json.enable = false;
}
