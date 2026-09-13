{ pkgs, ... }:

{
  # ------------------------------------------------------------
  # Platform
  # ------------------------------------------------------------
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Allow only the unfree package(s) we explicitly want.
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "terraform"
    ];

  # Determinate Nix already manages Nix itself.
  nix.enable = false;

  # Required by nix-darwin.
  system.stateVersion = 6;

  # ------------------------------------------------------------
  # Primary user
  # ------------------------------------------------------------
  system.primaryUser = "amar";

  users.users.amar = {
    name = "amar";
    home = "/Users/amar";
  };

  # ------------------------------------------------------------
  # Core system packages
  # ------------------------------------------------------------
  environment.systemPackages = with pkgs; [
    git
    gh
  ];

  # ------------------------------------------------------------
  # Shell
  # ------------------------------------------------------------
  programs.zsh.enable = true;

  # ------------------------------------------------------------
  # Homebrew managed through Nix
  # ------------------------------------------------------------
  nix-homebrew = {
    enable = true;
    user = "amar";

    # No Intel/Rosetta Homebrew needed right now.
    enableRosetta = false;

    # Adopt an existing Homebrew installation if one exists.
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
      # Terminals
      "wezterm"
      "iterm2"

      # Editors
      "visual-studio-code"
      "cursor"
      "sublime-text"

      # Browsers
      "google-chrome"
      "firefox"

      # Knowledge
      "obsidian"

      # Utilities
      "stats"
      "raycast"
      "rectangle"
    ];
  };
}