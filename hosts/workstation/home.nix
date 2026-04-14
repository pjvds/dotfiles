{ lib, ... }: {
  imports = [ ../../modules/home ];

  home.username = "pvandesande";
  home.homeDirectory = "/Users/pvandesande";

  my.kanata.enable = lib.mkForce true;
}
