{ pkgs, ... }: {
  home.packages = with pkgs; [
    go
    nodejs_22
    pnpm
    yarn
    python3
    rustup
    nil # nix lsp
  ];
}
