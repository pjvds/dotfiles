{ config, pkgs, ... }: {
  # Home Manager needs a bit of information about you and the paths it should manage
  home = {
    username = "pvandesande";
    homeDirectory = "/Users/pvandesande";
    stateVersion = "24.11";
    
    # Empty packages for now
    packages = [ ];
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
