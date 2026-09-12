{ pkgs, ... }:

{
  home.username = "amar";
  home.homeDirectory = "/Users/amar";

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    ripgrep
    fd
  ];
}
