{ config, pkgs, ... }: {
  home.file = {
    ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/kitty";
    ".config/alacritty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/alacritty";
    ".config/atuin".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/atuin";
    ".config/httpie".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/httpie";
    ".ssh/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ssh/config";
  };
}
