{ lib, ... }: {
  imports = [ ../../modules/darwin ];

  networking.hostName = "NL-F2T6KVCQ3G";
  system.primaryUser = "pvandesande";

  users.users.pvandesande = {
    name = "pvandesande";
    home = "/Users/pvandesande";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.pvandesande = import ./home.nix;
  };

  my.obsidian.enable = true;
  my.karabiner.enable = lib.mkForce false;
  my.lazyworktree.enable = true;
}
