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
      username = "pvandesande";
      hostname = "NL-F2T6KVCQ3G";
      system = "aarch64-darwin";
    in
    {
      # macOS system configuration (requires sudo)
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ./darwin
        ];
      };

      # Home Manager user configuration (no sudo required)
      homeConfigurations."${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          ./home
        ];
      };
    };
}
