{ config, ... }: {
  home.file.".config/alacritty".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/alacritty";
}
