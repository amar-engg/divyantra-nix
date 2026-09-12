{ pkgs, ... }:

{
  # Apple Silicon
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Determinate Nix already manages Nix itself.
  nix.enable = false;

  # Required by nix-darwin.
  system.stateVersion = 6;

  # Our macOS user.
  users.users.amar = {
    name = "amar";
    home = "/Users/amar";
  };

  # Minimal packages for now.
  environment.systemPackages = with pkgs; [
    git
  ];

  programs.zsh.enable = true;
}
