{ ... }: {
  imports = [
    ../../modules/home
    ../../modules/home/pjvds.nix
  ];

  home.username = "pjvds";
  home.homeDirectory = "/Users/pjvds";
}
