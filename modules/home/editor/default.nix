{ config, pkgs, lib, ... }:
let
  cfg = config.my.editor;
  home = config.home.homeDirectory;
in
{
  options.my.editor.enable = lib.mkEnableOption "neovim and vim editors";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      neovim
      vim
    ];

    home.file = {
      ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${home}/dotfiles/modules/home/editor/config/nvim";
      ".vim".source         = config.lib.file.mkOutOfStoreSymlink "${home}/dotfiles/modules/home/editor/config/vim";
      ".vimrc".source       = config.lib.file.mkOutOfStoreSymlink "${home}/dotfiles/modules/home/editor/config/vim/init.vim";
    };

    programs.zsh = {
      shellAliases = {
        v    = "nvim";
        vim  = "nvim";
        "v." = "v .";
      };
      initContent = ''
        export ZVM_VI_ESCAPE_BINDKEY=jj
        export ZVM_LINE_INIT_MODE=i

        autoload -Uz edit-command-line
        zle -N edit-command-line
        bindkey -M vicmd 'v' edit-command-line

        export VISUAL="nvim"
        export EDITOR="nvim"
        export SUDO_EDITOR="${pkgs.neovim}/bin/nvim"
      '';
    };
  };
}
