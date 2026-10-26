{ config, lib, ... }:
let
  cfg = config.my.claudeCode;
in {
  options.my.claudeCode.enable = lib.mkEnableOption "Claude Code CLI";

  config = lib.mkIf cfg.enable {
    # Prebuilt cask; avoids building from nixpkgs
    homebrew.casks = lib.mkAfter [ "claude-code" ];
  };
}
