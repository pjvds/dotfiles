{ pkgs, ... }: {
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
    yq
    pv
    delta # better git diffs
    helix
    tmux
    starship
    atuin
    direnv
  ];
}
