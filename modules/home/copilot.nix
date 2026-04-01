{ pkgs, lib, config, ... }:
let cfg = config.my.copilot; in
{
  options.my.copilot.enable = lib.mkEnableOption "GitHub Copilot CLI";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      github-copilot-cli
    ];
  };
}
