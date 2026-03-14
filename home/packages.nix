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
    the_silver_searcher
    tig
    tldr
    tree
    wget
    yq
    pv

    # Development Tools
    gh
    git
    git-filter-repo
    delta # better git diffs
    helix
    neovim
    tmux
    starship
    atuin
    direnv

    # Languages & Runtimes
    go
    nodejs_22
    pnpm
    yarn
    python3
    rustup
    nil # nix lsp

    # DevOps & Cloud
    awscli2
    azure-cli
    google-cloud-sdk
    kubectl
    kubectx
    kubens
    k9s
    helm
    k3d
    argo
  ];
}
