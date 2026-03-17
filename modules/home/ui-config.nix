{ config, pkgs, ... }: {
  home.file = {
    ".config/sketchybar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/sketchybar";
    ".config/aerospace".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/aerospace";
    ".config/borders".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/borders";
  };
}
