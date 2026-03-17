{ pkgs, ... }: {
  home.packages = with pkgs; [
    go
    nodejs_22
    pnpm
    yarn
    rustup
    nil # nix lsp
  ];
}
