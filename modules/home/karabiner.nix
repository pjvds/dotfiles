{ config, lib, ... }:
let cfg = config.my.karabiner; in
{
  options.my.karabiner.enable = lib.mkEnableOption "Karabiner keyboard configuration";

  config = lib.mkIf cfg.enable {
    home.file.".config/karabiner".source =
      config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/dotfiles/karabiner";
  };
}
