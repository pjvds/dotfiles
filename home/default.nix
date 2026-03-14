{ config, pkgs, ... }: {
  # Import program-specific configurations
  imports = [
    ./programs/opencode.nix
    ./programs/zsh.nix
    ./programs/git.nix
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
