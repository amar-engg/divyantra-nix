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
    gh
  ];

  programs.zsh.enable = true;

system.primaryUser = "amar";

nix-homebrew = {
  enable = true;
  user = "amar";

  # We do not need Intel/Rosetta Homebrew yet.
  enableRosetta = false;

  # If Homebrew ever already exists, adopt it.
  autoMigrate = true;
};

homebrew = {
  enable = true;

  onActivation = {
    autoUpdate = true;
    upgrade = false;
    cleanup = "none";
  };

casks = [
  "wezterm"
  "iterm2"

  "visual-studio-code"
  "cursor"

  "google-chrome"
  "firefox"

  "obsidian"

  "stats"
  "raycast"
  "rectangle"
];

};


}

