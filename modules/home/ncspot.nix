{ pkgs, config, ... }: {
  home.packages = [ pkgs.ncspot ];

  # Live-editable ncspot config without rebuild
  home.file.".config/ncspot".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/ncspot";
}
