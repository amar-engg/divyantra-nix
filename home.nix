{ pkgs, ... }:

{
  home.username = "amar";
  home.homeDirectory = "/Users/amar";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # ------------------------------------------------------------
  # Command-line packages
  # ------------------------------------------------------------
  home.packages = with pkgs; [
    ripgrep
    fd

    bat
    eza
    jq
    yq
    tree
    btop

    lazygit

    python3
    uv


    nodejs
    pnpm
  
  ];

  # ------------------------------------------------------------
  # Zsh + Oh My Zsh
  # ------------------------------------------------------------
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

      # Starship handles the prompt.
      theme = "";
    };

    shellAliases = {
      ll = "eza -lah";
      la = "eza -a";
      cat = "bat";

      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";

      lg = "lazygit";
    };
  };

  # ------------------------------------------------------------
  # Starship prompt
  # ------------------------------------------------------------
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # ------------------------------------------------------------
  # Fuzzy finder
  # ------------------------------------------------------------
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # ------------------------------------------------------------
  # Smarter directory navigation
  # ------------------------------------------------------------
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # ------------------------------------------------------------
  # Git
  # ------------------------------------------------------------
  programs.git = {
    enable = true;
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  # ------------------------------------------------------------
  # tmux
  # ------------------------------------------------------------
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

  # ------------------------------------------------------------
  # WezTerm
  # ------------------------------------------------------------
  home.file.".wezterm.lua".text = ''
    local wezterm = require 'wezterm'

    local config = wezterm.config_builder()

    config.font_size = 14.0

    config.enable_tab_bar = true
    config.hide_tab_bar_if_only_one_tab = true
    config.use_fancy_tab_bar = false

    config.window_decorations = "RESIZE"
    config.scrollback_lines = 10000

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

