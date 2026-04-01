{ pkgs, lib, config, ... }:
let cfg = config.my.core; in
{
  options.my.core.enable = lib.mkEnableOption "core CLI tools and direnv";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # Core CLI Tools
      bat
      eza
      fd
      fzf
      htop
      jq
      ncdu
      ripgrep
      silver-searcher
      tig
      tldr
      tree
      wget
      httpie
      yq
      pv
      delta # better git diffs
      helix
    ];

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
