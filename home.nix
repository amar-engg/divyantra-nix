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
    tmux
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

programs.tmux = {
  enable = true;

  terminal = "screen-256color";

  mouse = true;
  clock24 = true;

  historyLimit = 100000;

  extraConfig = ''
    set -g base-index 1
    setw -g pane-base-index 1
    set -g renumber-windows on

    set -g status-interval 5

    # Easier pane navigation
    bind h select-pane -L
    bind j select-pane -D
    bind k select-pane -U
    bind l select-pane -R

    # Easier pane splitting
    bind | split-window -h
    bind - split-window -v

    # Reload config
    bind r source-file ~/.config/tmux/tmux.conf \; display-message "tmux config reloaded"
  '';
};

home.file.".wezterm.lua".text = ''
  local wezterm = require 'wezterm'

  local config = wezterm.config_builder()

  config.font_size = 14.0

  config.enable_tab_bar = true
  config.hide_tab_bar_if_only_one_tab = true

  config.window_decorations = "RESIZE"

  config.scrollback_lines = 10000

  config.use_fancy_tab_bar = false

  config.color_scheme = "Builtin Solarized Dark"

  config.window_padding = {
    left = 10,
    right = 10,
    top = 8,
    bottom = 8,
  }

  return config
'';

}
