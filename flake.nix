{
  description = "Divyantra macOS development and AI workstation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    nix-openclaw.url = "github:openclaw/nix-openclaw";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      nix-homebrew,
      nix-openclaw,
      ...
    }:
    {
      darwinConfigurations.divyantra = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";

        modules = [
          ./configuration.nix

          # Make nix-openclaw packages available through pkgs.
          {
            nixpkgs.overlays = [
              nix-openclaw.overlays.default
            ];
          }

          # Declarative Homebrew management.
          nix-homebrew.darwinModules.nix-homebrew

          # Home Manager.
          home-manager.darwinModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # OpenClaw Home Manager module.
            home-manager.sharedModules = [
              nix-openclaw.homeManagerModules.openclaw
            ];

            home-manager.users.amar = import ./home.nix;
          }
        ];
      };
    };
}