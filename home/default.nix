{ config, pkgs, lib, ... }: {
  imports = [
    ../modules/home/core.nix
    ../modules/home/languages.nix
    ../modules/home/cloud-k8s.nix
    ../modules/home/zsh.nix
    ../modules/home/git.nix
    ../modules/home/opencode.nix
    ../modules/home/editor.nix
    ../modules/home/maccy.nix
    ../modules/home/python.nix
    # Per-app modules (each owns its install + config)
    ../modules/home/tmux.nix
    ../modules/home/atuin.nix
    ../modules/home/kitty.nix
    ../modules/home/alacritty.nix
    ../modules/home/karabiner.nix
    ../modules/home/sketchybar.nix
    ../modules/home/aerospace.nix
    ../modules/home/borders.nix
    ../modules/home/ssh.nix
    ../modules/home/httpie.nix
    ../modules/home/yabai.nix
    ../modules/home/skhd.nix
    ../modules/home/netskope.nix
    ../modules/home/ncspot.nix
    ../modules/home/dotnet.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should manage
  home = {
    username = lib.mkDefault "pvandesande";
    homeDirectory = lib.mkDefault "/Users/pvandesande";
    stateVersion = "24.11";
    
    # Packages to install
    packages = with pkgs; [
      opencode
    ];
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Disable manual/documentation generation to speed up rebuilds
  manual.manpages.enable = false;
  manual.html.enable = false;
  manual.json.enable = false;
}
