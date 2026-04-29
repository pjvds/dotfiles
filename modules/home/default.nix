{ config, pkgs, lib, ... }: {
  imports = [
    ./core.nix
    ./languages.nix
    ./cloud-k8s
    ./zsh
    ./git
    ./opencode
    ./editor
    ./maccy.nix
    ./python.nix
    # Per-app modules (each owns its install + config)
    ./tmux
    ./atuin.nix
    ./alacritty
    ./ssh
    ./httpie
    ./netskope.nix
    ./ncspot
    ./dotnet.nix
    ./apps.nix
    ./raycast.nix
    ./flutter.nix
    ./theme
    ../programs/node
    ../programs/kanata
  ];

  my.core.enable       = true;
  my.zsh.enable        = true;
  my.git.enable        = true;
  my.languages.enable  = true;
  my.cloudK8s.enable   = true;
  my.editor.enable     = true;
  my.python.enable     = true;
  my.dotnet.enable     = true;
  my.opencode.enable   = true;
  my.tmux.enable       = true;
  my.atuin.enable      = true;
  my.alacritty.enable  = true;
  my.ssh.enable        = true;
  my.httpie.enable     = true;
  my.netskope.enable   = true;
  my.ncspot.enable     = true;
  my.apps.enable       = true;
  my.maccy.enable      = false;
  my.raycast.enable    = true;
  my.node.enable       = true;
  my.kanata.enable     = false;
  my.theme.enable      = true;

  home = {
    stateVersion = "25.05";
    packages = with pkgs; [
      opencode
    ];
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Link apps into ~/Applications so Spotlight can index them
  targets.darwin.linkApps.enable = true;

  # Disable manual/documentation generation to speed up rebuilds
  manual.manpages.enable = false;
  manual.html.enable = false;
  manual.json.enable = false;
}

