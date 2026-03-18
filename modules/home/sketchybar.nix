{ config, ... }: {
  home.file.".config/sketchybar".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/sketchybar";
}
