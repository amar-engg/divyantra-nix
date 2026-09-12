{
  description = "Divyantra macOS development and AI workstation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, nix-homebrew, ... }:
  {
    darwinConfigurations.divyantra = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";

      modules = [
        ./configuration.nix
	
	nix-homebrew.darwinModules.nix-homebrew

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.amar = import ./home.nix;
        }
      ];
    };
  };
}
