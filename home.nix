{ pkgs, ... }:

{
  home.username = "amar";
  home.homeDirectory = "/Users/amar";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    ripgrep
    fd
    fzf
    zoxide
    starship
  ];

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;

      plugins = [
        "git"
        "sudo"
        "history"
        "docker"
        "aws"
        "terraform"
      ];

      theme = "";
    };

    shellAliases = {
      ll = "ls -lah";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
