{ config, ... }: {
  home.file.".config/httpie".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/httpie";
}
