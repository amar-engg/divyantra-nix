{ pkgs, ... }:

let
  # ------------------------------------------------------------
  # OpenCode local launcher
  #
  # Usage:
  #   cd ~/projects/my-project
  #   oc
  #
  # Starts llama.cpp + Qwen3-Coder automatically if the
  # local server is not already running, then launches OpenCode.
  # ------------------------------------------------------------
  opencodeLocal = pkgs.writeShellScriptBin "oc" ''
    LLAMA_URL="http://127.0.0.1:8080"
    LLAMA_LOG="/tmp/llama-server.log"
    STARTED_LLAMA=0

    if ! ${pkgs.curl}/bin/curl -s "$LLAMA_URL/health" >/dev/null 2>&1; then
      echo "Starting Qwen3-Coder via llama.cpp..."

      nohup ${pkgs.llama-cpp}/bin/llama-server \
        -hf wekW/Qwen3-Coder-30B-A3B-Instruct-Q4_K_M-GGUF:Q4_K_M \
        -c 32768 \
        --parallel 1 \
        --host 127.0.0.1 \
        --port 8080 \
        > "$LLAMA_LOG" 2>&1 &

      LLAMA_PID=$!
      STARTED_LLAMA=1

      echo "Waiting for llama-server..."

      count=0
      until ${pkgs.curl}/bin/curl -s "$LLAMA_URL/health" >/dev/null 2>&1; do
        sleep 1
        count=$((count + 1))

        if [ "$count" -ge 120 ]; then
          echo "llama-server did not become ready."
          kill "$LLAMA_PID" 2>/dev/null || true
          exit 1
        fi
      done

      echo "llama-server ready."
    fi

    ${pkgs.opencode}/bin/opencode "$@"
    OPENCODE_EXIT=$?

    if [ "$STARTED_LLAMA" -eq 1 ]; then
      echo "Stopping llama-server..."
      kill "$LLAMA_PID" 2>/dev/null || true
    fi

    exit "$OPENCODE_EXIT"
  '';

in
{
  home.username = "amar";
  home.homeDirectory = "/Users/amar";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # Explicitly make macOS GUI applications from Home Manager
  # available under ~/Applications/Home Manager Apps.
  #
  # This is already the default for stateVersion >= 25.11,
  # but keeping it explicit makes our intent clear.
  targets.darwin.copyApps.enable = true;

  # ------------------------------------------------------------
  # Command-line packages
  # ------------------------------------------------------------
  home.packages = with pkgs; [
    # Search / navigation
    ripgrep
    fd

    # CLI utilities
    bat
    eza
    jq
    yq
    tree
    btop

    # Git
    lazygit

    # Python
    python3
    uv

    # JavaScript / Node
    nodejs
    pnpm

    # Java
    jdk21
    maven
    gradle

    # Cloud / Infrastructure
    awscli2
    terraform

    # Data
    duckdb

    # Editors
    neovim

    # AI / Local coding
    opencode
    llama-cpp
    opencodeLocal

    # Do NOT add openclaw here.
    # programs.openclaw below owns it.
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

      # View llama.cpp server log
      lmlog = "tail -f /tmp/llama-server.log";

      # Stop local llama.cpp model server
      lmstop = "pkill llama-server";
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

  # ------------------------------------------------------------
  # OpenClaw
  #
  # nix-openclaw owns:
  #   - OpenClaw CLI
  #   - OpenClaw macOS app
  #   - Gateway launchd service
  #
  # We will add gateway auth, models, channels and workspace
  # configuration in the next step.
  # ------------------------------------------------------------
  programs.openclaw = {
    enable = true;

    runtimePlugins = [
      "llama-cpp"
    ];
  };
}
