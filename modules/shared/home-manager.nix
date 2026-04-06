{ config, pkgs, lib, ... }:

let
  mdopen = pkgs.callPackage ../../packages/mdopen.nix {};
  claude-agent-acp = pkgs.callPackage ../../packages/claude-agent-acp.nix {};
  codex-acp = pkgs.callPackage ../../packages/codex-acp.nix {};
in
{
  # Disable Home Manager release check since we're using flake pinning
  home.enableNixpkgsReleaseCheck = false;
  home.stateVersion = "24.11";

  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      withNodeJs = true;
    };

    btop.enable = true;

    git = {
      enable = true;

      signing = {
        format = "openpgp";
        key = "55A043A0";
        signByDefault = true;
      };

      settings = {
        user = {
          name = "regadas";
          email = "oss@regadas.email";
        };

        alias = {
          s = "status";
          l =
            "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        };

        color.ui = true;
        branch.autosetuprebase = "always";
        rebase.autoStash = true;
        pull.rebase = true;
        init.defaultBranch = "main";
        push.default = "tracking";
        hub.host = "ghe.spotify.net";
        hub.protocol = "ssh";
        github.user = "regadas";
        github."ghe.spotify.net/api/v3".user = "regadas";
      };

      ignores = [
        ".java_version"
        ".metals"
        "metals.sbt"
        ".bloop"
        ".idea"
        ".DS_Store"
        ".projectile"
        ".direnv"
        ".claude/setting.local.json"
        ".agent-shell"
      ];
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
    };

    tmux = {
      enable = true;
      terminal = "xterm-256color";
      baseIndex = 1;
      keyMode = "vi";
      shortcut = "s";
      plugins = with pkgs.tmuxPlugins; [ sensible yank catppuccin ];

      extraConfig = ''
        # -- Catppuccin theme (set before plugin loads) --
        set -g @catppuccin_flavor "mocha"
        set -g @catppuccin_status_background "none"

        # Window tabs
        set -g @catppuccin_window_status_style "basic"
        set -g @catppuccin_window_number_position "left"
        set -g @catppuccin_window_text " #W"
        set -g @catppuccin_window_current_text " #W"
        set -g @catppuccin_window_flags "icon"

        # Pane borders
        set -g @catppuccin_pane_border_style "fg=#{@thm_surface_0}"
        set -g @catppuccin_pane_active_border_style "fg=#{@thm_lavender}"

        set -ga terminal-overrides ",xterm-256color*:Tc"
        set -g mouse on
        set -sg escape-time 100

        set-option -g status-position top
        set-option -g default-shell $SHELL
        set-option -g default-command $SHELL

        # Status bar — windows only
        set -g status-left " "
        set -g status-right ""

        # New panes open in the same directory
        bind '"' split-window -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"

        # act like vim
        bind-key h select-pane -L
        bind-key j select-pane -D
        bind-key k select-pane -U
        bind-key l select-pane -R
        bind-key -r C-h select-window -t :-
        bind-key -r C-l select-window -t :+

        # Navigate panes with Shift+Ctrl+hjkl
        bind-key -n C-S-h select-pane -L
        bind-key -n C-S-j select-pane -D
        bind-key -n C-S-k select-pane -U
        bind-key -n C-S-l select-pane -R

        # renumber windows sequentially after closing any of them
        set -g renumber-windows on

        # prefix -> back-one-character
        bind-key C-b send-prefix
        # prefix-2 -> forward-incremental-history-search
        bind-key C-s send-prefix -2

        # don't suspend-client
        unbind-key C-z

        bind-key -T copy-mode-vi WheelUpPane send -N1 -X scroll-up
        bind-key -T copy-mode-vi WheelDownPane send -N1 -X scroll-down
      '';
    };

    nushell = {
      enable = true;

      settings = { show_banner = false; };

      environmentVariables = {
        EDITOR = "code";
        VISUAL = "code";
        PAGER = "less";
        LESS = "-R";
        USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
        LSP_USE_PLISTS = "True";
        DIRENV_LOG_FORMAT = "";
        # SHELL = "nu";
      };

      shellAliases = {
        cat = "bat";
        git = "hub";
        k = "kubectl";
      };
    };

    fish = {
      enable = true;
      plugins = [
        {
          name = "bass";
          src = pkgs.fetchFromGitHub {
            owner = "edc";
            repo = "bass";
            rev = "79b62958ecf4e87334f24d6743e5766475bcf4d0";
            sha256 = "sha256-3d/qL+hovNA4VMWZ0n1L+dSM1lcz7P5CQJyy+/8exTc=";
          };
        }
        {
          name = "hydro";
          src = pkgs.fetchFromGitHub {
            owner = "jorgebucaran";
            repo = "hydro";
            rev = "75ab7168a35358b3d08eeefad4ff0dd306bd80d4";
            sha256 = "sha256-QYq4sU41/iKvDUczWLYRGqDQpVASF/+6brJJ8IxypjE=";
          };
        }
      ];
      shellInit = ''
        set -g EDITOR "nvim"
        set -U fish_greeting

        set -g hydro_multiline true

        # set -ga PATH ${config.xdg.configHome}/bin
        fish_add_path -gm $HOME/.local/bin
        fish_add_path -gm $HOME/go/bin
        fish_add_path -gm $HOME/.krew/bin
        fish_add_path -gm $HOME/.cargo/bin

        if test $KERNEL_NAME darwin
          fish_add_path -gm /opt/homebrew/opt/llvm/bin
          fish_add_path -gm /opt/homebrew/bin
          fish_add_path -gm /opt/homebrew/sbin
        end

        fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin

        set -gx USE_GKE_GCLOUD_AUTH_PLUGIN True
        set -gx LSP_USE_PLISTS True
        set -gx DIRENV_LOG_FORMAT ""
      '';

      shellAliases = {
        cat = "bat";
        git = "hub";
        k = "kubectl";
      };
    };

    broot.enable = true;

    bat = {
      enable = true;
      config.theme = "ansi";
    };

    fzf = {
      enable = true;

      defaultOptions = [ "--color=light" ];

      fileWidgetOptions = [
        "--preview '${
          lib.getExe pkgs.bat
        } --color=always --plain --line-range=:200 {}'"
      ];
      changeDirWidgetOptions =
        [ "--preview '${lib.getExe pkgs.tree}  -C {} | head -200'" ];
    };

    wezterm = {
      enable = true;
      extraConfig = ''
        return {
          front_end = "WebGpu",
          font = wezterm.font("Iosevka SS14"),
          font_size = 15.0,
          color_scheme = "catppuccin-mocha",
          hide_tab_bar_if_only_one_tab = true,
        }
      '';
    };

    alacritty = {
      enable = true;
      settings = {
        window = {
          # decorations = "none";
          option_as_alt = "Both";
        };
        font = {
          size = 16;
          normal = { family = "Iosevka SS14"; };
          bold = {
            family = "Iosevka SS14";
            style = "bold";
          };
          italic = {
            family = "Iosevka SS14";
            style = "italic";
          };
        };
      };
    };

    vscode = { enable = true; };

    java = {
      enable = true;
      package = pkgs.temurin-bin-21;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;

      stdlib = ''
        layout_uv() {
            if [[ -d ".venv" ]]; then
                VIRTUAL_ENV="$(pwd)/.venv"
            fi

            if [[ -z $VIRTUAL_ENV || ! -d $VIRTUAL_ENV ]]; then
                log_status "No virtual environment exists. Executing \`uv venv\` to create one."
                uv venv
                VIRTUAL_ENV="$(pwd)/.venv"
            fi

            PATH_add "$VIRTUAL_ENV/bin"
            export UV_ACTIVE=1  # or VENV_ACTIVE=1
            export VIRTUAL_ENV
        }
      '';
    };

    texlive = {
      enable = true;
      extraPackages = tpkgs: { inherit (tpkgs) scheme-full; };
    };

    lsd = {
      enable = true;
      settings = { icons.when = "never"; };
    };

    zoxide.enable = true;

    zellij = {
      enable = true;
      enableFishIntegration = false;

      settings = {
        keybinds = {
          unbind = [ "Ctrl o" ];
          session = { "bind \"Ctrl x\"" = { SwitchToMode = "Normal"; }; };
          "shared_except \"session\" \"locked\"" = {
            "bind \"Ctrl x\"" = { SwitchToMode = "Session"; };
          };
        };
      };
    };

    atuin = {
      enable = false;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      daemon.enable = true;
    };
  };

  home.packages = with pkgs;
    [
      mdopen
      claude-agent-acp
      codex-acp
      copilot-language-server
      obsidian
      sesh
      cachix
      gemini-cli-bin
      # claude-code
      talosctl
      pqrs
      uv
      ffmpegthumbnailer
      tree
      ffmpeg
      gh-dash
      ookla-speedtest
      ruby-lsp
      just-lsp
      devenv
      duckdb
      fd
      hadolint
      avro-tools
      ocaml
      opam
      ocamlPackages.ocaml-lsp
      ocamlPackages.utop
      grpcurl
      git-absorb
      fx
      krew
      marksman
      httpie
      d2
      google-cloud-sql-proxy
      k9s
      pluto
      dockerfile-language-server
      ltex-ls
      languagetool
      nixd
      jdt-language-server
      texlab
      editorconfig-checker
      hugo
      # colima
      act
      # bazel_7
      bazel-buildtools
      coreutils
      curl
      deno
      dhall
      dhall-json
      dhall-lsp-server
      duf
      html-tidy
      gettext
      hub
      gh
      gnupg
      gnused
      go
      (google-cloud-sdk.withExtraComponents
        [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
      gopls
      gradle
      graphviz-nox
      imagemagick
      jq
      kind
      kubebuilder
      kubectx
      kubernetes
      kubernetes-helm
      kustomize
      leiningen
      maven
      metals
      minikube
      nixfmt
      nixpkgs-fmt
      mermaid-cli
      sqlfluff
      prettier
      sql-formatter
      typescript
      typescript-language-server
      yaml-language-server
      vscode-json-languageserver
      yarn
      pyright
      bash-language-server
      markdownlint-cli2
      nodejs
      operator-sdk
      pandoc
      parallel
      protobuf
      ruby
      python313
      python313Packages.sqlparse
      python313Packages.python-lsp-server
      go-grip
      ripgrep
      rustup
      coursier
      sbt
      scala
      scala-cli
      scalafmt
      shellcheck
      silver-searcher
      trino-cli
      watch
      wget
      yarn2nix
      yq-go
    ] ++ lib.optionals stdenv.isDarwin [
      cocoapods
      m-cli # useful macOS CLI commands
    ];

}
