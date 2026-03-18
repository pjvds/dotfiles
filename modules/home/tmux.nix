{ pkgs, config, ... }: {
  home.packages = [ pkgs.tmux ];

  home.file.".tmux.conf".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/tmux/tmux.conf";
}
