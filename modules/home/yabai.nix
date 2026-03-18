{ config, ... }: {
  home.file.".config/yabai".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/dotfiles/yabai";
}
