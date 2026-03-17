{ config, pkgs, ... }: {
  # OpenCode AI editor configuration
  # Symlinks the entire opencode directory to ~/.config/opencode
  # Using mkOutOfStoreSymlink so that edits to AGENTS.md, themes, etc. 
  # are reflected immediately without a Nix rebuild.
  home.file.".config/opencode".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/opencode";
}
