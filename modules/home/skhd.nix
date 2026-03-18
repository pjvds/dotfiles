{ config, ... }: {
  home.file.".config/skhd".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/dotfiles/skhd";
}
