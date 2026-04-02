{ lib, config, ... }:
let cfg = config.my.copilot; in
{
  options.my.copilot.enable = lib.mkEnableOption "GitHub Copilot CLI";

  config = lib.mkIf cfg.enable {
    # Symlinks the entire copilot directory to ~/.copilot
    # Using mkOutOfStoreSymlink so that edits to mcp.json, copilot-instructions.md, etc.
    # are reflected immediately without a Nix rebuild.
    #
    # NOTE: Remove ~/.copilot before the first darwin-rebuild switch to allow the symlink:
    #   rm -rf ~/.copilot && darwin-rebuild switch --flake .#workstation
    home.file.".copilot".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/copilot";

    programs.zsh.shellAliases = {
      c = "copilot";
      # Copilot with prompts, e.g. `c -p "Write a function that adds two numbers in Python"`
      cp = "c -p ";
    };
  };
}
