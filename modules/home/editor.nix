{ config, pkgs, lib, ... }:
let cfg = config.my.editor; in
{
  options.my.editor.enable = lib.mkEnableOption "neovim and vim editors";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      neovim
      vim
    ];

    home.file = {
      ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
      ".vim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/vim";
      ".vimrc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/vim/init.vim";
    };
  };
}
