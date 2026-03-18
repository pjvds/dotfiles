{ pkgs, config, ... }: {
  home.packages = [ pkgs.atuin ];

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  # Live-editable atuin config without rebuild
  home.file.".config/atuin".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/atuin";
}
