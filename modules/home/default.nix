{ config, pkgs, lib, ... }: {
  imports = [
    ./core.nix
    ./languages.nix
    ./cloud-k8s
    ./zsh
    ./git
    ./opencode
    ./editor
    ./python.nix
    # Per-app modules (each owns its install + config)
    ./tmux
    ./atuin.nix
    ./asciinema.nix
    ./ssh
    ./httpie
    ./netskope.nix
    ./ncspot
    ./dotnet.nix
    ./apps.nix
    ./raycast.nix
    ./flutter.nix
    ./spec-kit.nix
    ./theme
    ./fonts
    ../programs/node
    ../programs/kanata
    ../programs/shortcat
    ../programs/codedb
    ../programs/chrome
    ./z
    ./docker
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
  my.asciinema.enable  = true;
  my.ssh.enable        = true;
  my.httpie.enable     = true;
  my.netskope.enable   = true;
  my.ncspot.enable     = true;
  my.apps.enable       = true;
  my.raycast.enable    = true;
  my.specKit.enable    = true;
  my.node.enable       = true;
  my.kanata.enable     = false;
  my.shortcat.enable   = true;
  my.codedb.enable     = true;
  my.chrome.enable     = true;
  my.z.enable          = true;
  my.docker.enable     = true;
  my.flutter.enable    = true;
  my.theme.enable      = true;
  my.fonts.enable      = true;

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
