{ pkgs, config, lib, ... }:
let cfg = config.my.tmux; in
{
  options.my.tmux.enable = lib.mkEnableOption "tmux";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.tmux ];

    home.file.".tmux.conf".source =
      config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/dotfiles/tmux/tmux.conf";
  };
}
