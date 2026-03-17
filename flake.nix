{
  description = "pvandesande's macOS dotfiles with nix-darwin + Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager }: 
    let
      system = "aarch64-darwin";
    in
    {
      # macOS system configuration (requires sudo)
      darwinConfigurations = {
        "NL-F2T6KVCQ3G" = nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [ ./darwin ];
        };

        "Pieters-MacBook-Pro" = nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [ ./darwin ];
        };
      };

      # Home Manager user configuration (no sudo required)
      homeConfigurations = {
        "pvandesande@NL-F2T6KVCQ3G" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [ ./home ];
        };

        "pjvds@Pieters-MacBook-Pro" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [ 
            ./home
            {
              home.username = "pjvds";
              home.homeDirectory = "/Users/pjvds";
            }
          ];
        };
      };
    };
}
