{ config, ... }: {
  home.file.".config/aerospace".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/aerospace";
}
