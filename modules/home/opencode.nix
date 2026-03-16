{ config, pkgs, ... }: {
  # OpenCode AI editor configuration
  # Symlinks the entire opencode directory to ~/.config/opencode
  xdg.configFile."opencode" = {
    source = ../../opencode;
    recursive = true;
  };
}
