{ pkgs, config, lib, ... }: {
  home.packages = [ pkgs.atuin ];

  # If ~/.config/atuin is a symlink (e.g. leftover from the old mkOutOfStoreSymlink
  # setup or a dangling GC'd store path), remove it before home-manager tries to
  # create the directory. Without this, atuin fails with "File exists (os error 17)".
  home.activation.cleanAtuinSymlink = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    if [[ -L "${config.home.homeDirectory}/.config/atuin" ]]; then
      rm "${config.home.homeDirectory}/.config/atuin"
    fi
  '';

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    forceOverwriteSettings = true;
    settings = {
      style        = "full";
      enter_accept = true;
      sync.records = true;
    };
  };
}
