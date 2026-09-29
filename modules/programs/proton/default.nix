{ config, lib, ... }:
let
  cfg = config.my.proton;
  user = config.system.primaryUser;
in {
  options.my.proton.enable = lib.mkEnableOption "Proton Pass";

  config = lib.mkIf cfg.enable {
    homebrew.casks = [ "proton-pass" ];

    home-manager.users.${user} = { pkgs, ... }: {
      home.packages = [ pkgs.proton-pass-cli ];
    };
  };
}
