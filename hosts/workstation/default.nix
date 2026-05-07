{ lib, pkgs, config, ... }: {
  imports = [ ../../modules/darwin ];

  networking.hostName = "NL-F2T6KVCQ3G";
  system.primaryUser = "pvandesande";

  # Allow passwordless sudo for kanata (keyboard remapper, enabled on this host)
  security.sudo.extraConfig = ''
    ${config.system.primaryUser} ALL=(ALL) NOPASSWD: ${pkgs.kanata-with-cmd}/bin/kanata
  '';

  users.users.pvandesande = {
    name = "pvandesande";
    home = "/Users/pvandesande";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.pvandesande = import ./home.nix;
  };

  my.karabiner.enable = lib.mkForce false;
  my.lazyworktree.enable = true;
  my.warp.enable = true;
  my.snyk.enable = true;
}
