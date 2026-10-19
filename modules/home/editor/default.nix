{ config, pkgs, lib, ... }:
let
  cfg = config.my.editor;
  home = config.home.homeDirectory;
  springBootTools = pkgs.vscode-utils.buildVscodeExtension {
    pname = "vscode-spring-boot";
    version = "1.55.1";
    vscodeExtPublisher = "VMware";
    vscodeExtName = "vscode-spring-boot";
    vscodeExtUniqueId = "VMware.vscode-spring-boot";
    src = pkgs.fetchurl {
      url = "https://open-vsx.org/api/VMware/vscode-spring-boot/1.55.1/file/VMware.vscode-spring-boot-1.55.1.vsix";
      hash = "sha256-wA+VBjEJxXwhptuXBHidbpnCr3KnbtZ1JxJC0FonGHY=";
    };
  };
  managedTool = path: {
    inherit path;
    auto_install = false;
  };
in
{
  options.my.editor.enable = lib.mkEnableOption "neovim and vim editors";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      neovim
      vim
      fsautocomplete
      tree-sitter
    ];

    home.file = {
      ".config/nvim-java/tools.json".text = builtins.toJSON {
        jdtls = managedTool "${pkgs.jdt-language-server}/share/java/jdtls";
        jdk = managedTool pkgs.jdk25.home;
        lombok = managedTool "${pkgs.lombok}/share/java/lombok.jar";
        java_test = managedTool "${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test";
        java_debug_adapter = managedTool "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug";
        spring_boot_tools = managedTool "${springBootTools}/share/vscode/extensions/VMware.vscode-spring-boot";
      };
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

        export VISUAL="nvim"
        export EDITOR="nvim"
        export SUDO_EDITOR="${pkgs.neovim}/bin/nvim"
      '';
    };
  };
}
