{ config, ... }: {
  home.file.".config/kitty".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/kitty";
}
