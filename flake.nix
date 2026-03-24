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
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
          "proton-pass-cli"
          "android-studio"
          "discord"
          "idea"
          "obsidian"
          "raycast"
          "rider"
          "shortcat"
          "shottr"
          "vscode"
        ];
      };
    in
    {
      # macOS system configuration (requires sudo)
      darwinConfigurations = {
        "NL-F2T6KVCQ3G" = nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { hostname = "NL-F2T6KVCQ3G"; };
          modules = [ ./darwin ];
        };

        "Pieters-MacBook-Pro" = nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { hostname = "Pieters-MacBook-Pro"; };
          modules = [ ./darwin ];
        };
      };

      # Home Manager user configuration (no sudo required)
      homeConfigurations = {
        "pvandesande@NL-F2T6KVCQ3G" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home ];
        };

        "pjvds@Pieters-MacBook-Pro" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ 
            ./home
            ./modules/home/pjvds.nix
            {
              home.username = "pjvds";
              home.homeDirectory = "/Users/pjvds";
            }
          ];
        };
      };
    };
}
