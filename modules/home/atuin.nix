{ pkgs, ... }: {
  home.packages = [ pkgs.atuin ];

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
