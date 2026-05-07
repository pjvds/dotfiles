{ config, lib, pkgs, ... }:
with lib;
let cfg = config.my.kanata; in
{
  options.my.kanata = {
    enable = mkEnableOption "Kanata keyboard remapper";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ kanata-with-cmd ];

    home.file.".config/kanata/kanata.kbd".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/modules/programs/kanata/config/kanata.kbd";

    # LaunchAgent to start Kanata on login with sudo
    launchd.agents.kanata = {
      enable = true;
      config = {
        Label = "com.local.kanata";
        Program = "/usr/bin/sudo";
        ProgramArguments = [
          "/usr/bin/sudo"
          "${pkgs.kanata-with-cmd}/bin/kanata"
          "--cfg"
          "${config.home.homeDirectory}/.config/kanata/kanata.kbd"
        ];
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "${config.home.homeDirectory}/.local/share/kanata/out.log";
        StandardErrorPath = "${config.home.homeDirectory}/.local/share/kanata/err.log";
      };
    };
  };
}

