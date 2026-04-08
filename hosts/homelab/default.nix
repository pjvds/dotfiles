{ ... }: {
  imports = [ ../../modules/darwin ];

  networking.hostName = "Pieters-MacBook-Pro";
  system.primaryUser = "pjvds";

  users.users.pjvds = {
    name = "pjvds";
    home = "/Users/pjvds";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.pjvds = import ./home.nix;
  };

  my.obsidian.enable = true;

  # Homelab-specific casks
  homebrew.casks = [ "android-studio" ];
}
