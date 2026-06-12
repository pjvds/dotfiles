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
      pkgsConfig = {
        allowUnfree = true;
      };
    in
    {
      # macOS system configuration (requires sudo)
      darwinConfigurations = {
        "NL-F2T6KVCQ3G" = nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [
            { nixpkgs.config = pkgsConfig; }
            home-manager.darwinModules.home-manager
            ./hosts/workstation
          ];
        };

        "Pieters-MacBook-Pro" = nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [
            { nixpkgs.config = pkgsConfig; }
            home-manager.darwinModules.home-manager
            ./hosts/homelab
          ];
        };
      };
    };
}
