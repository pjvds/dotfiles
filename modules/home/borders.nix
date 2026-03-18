{ config, ... }: {
  home.file.".config/borders".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/borders";
}
