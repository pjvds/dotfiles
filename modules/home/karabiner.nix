{ config, ... }: {
  home.file.".config/karabiner".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/karabiner";
}
