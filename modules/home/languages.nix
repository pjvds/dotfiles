{ pkgs, lib, config, ... }:
let cfg = config.my.languages; in
{
  options.my.languages.enable = lib.mkEnableOption "programming languages (go, node, rust, nix lsp)";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      go
      nodejs_22
      pnpm
      yarn
      rustup
      nil # nix lsp
    ];
  };
}
