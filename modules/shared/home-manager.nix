{ config, pkgs, lib, ... }:

let
  mdopen = pkgs.callPackage ../../packages/mdopen.nix { };
  jdtls-wrapper = pkgs.callPackage ../../packages/jdtls-wrapper.nix { };
  claude-agent-acp = pkgs.callPackage ../../packages/claude-agent-acp.nix { };
  codex-acp = pkgs.callPackage ../../packages/codex-acp.nix { };
  pi-acp = pkgs.callPackage ../../packages/pi-acp.nix { };
  pi-coding-agent = pkgs.callPackage ../../packages/pi-coding-agent.nix { };
in
{
  # Disable Home Manager release check since we're using flake pinning
  home.enableNixpkgsReleaseCheck = false;
  home.stateVersion = "24.11";

  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "$HOME/.local";
  };

  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      withNodeJs = true;
      withRuby = false;
      withPython3 = false;

      # Load Home Manager's generated init (Node provider, etc.) via wrapper
      # args instead of writing ~/.config/nvim/init.lua. This keeps our own
      # externally-managed LazyVim config (git repo in ~/.config/nvim)
      # authoritative and avoids clobbering its init.lua on activation.
      sideloadInitLua = true;
    };

    # Helix — configured to mirror the Doom Emacs setup (~/.doom.d):
    #   * modal editing (native), with evil-style "jj" -> normal escape
    #   * relative line numbers, format-on-save, rich statusline
    #   * LSP + formatters for the same languages Doom enables. All servers
    #     are already provided by home.packages and resolved on $PATH; Helix
    #     derives `command = <server-name>` when no explicit block is given.
    helix = {
      enable = true;

      # Keep emacsclient as $EDITOR (set in fish/nushell); don't hijack it.
      defaultEditor = false;

      # Patched picker: show "filename  dir/" (VS Code Quick-Open style)
      # instead of "dir/filename". No upstream config option exists for this
      # (as of 25.07.1); rebase the patch when nixpkgs bumps helix.
      package = pkgs.helix.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          ./patches/helix-picker-filename-first.patch
        ];
      });

      settings = {
        # Match the terminals (Ghostty / WezTerm both use Catppuccin Mocha).
        theme = "catppuccin_mocha";

        editor = {
          line-number = "relative"; # Doom: display-line-numbers-type 'relative
          mouse = true;
          bufferline = "multiple";
          color-modes = true;
          cursorline = true;
          true-color = true;
          completion-trigger-len = 1;
          idle-timeout = 250; # Doom: lsp-idle-delay 0.25
          rulers = [ ];
          auto-format = true; # Doom: :editor format (format on save)

          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };

          file-picker.hidden = false;

          lsp = {
            display-messages = true;
            display-inlay-hints = false; # Doom kept lsp lens/inlay noise off
          };

          indent-guides.render = false; # Doom: indent-guides disabled
          soft-wrap.enable = false; # Doom: word-wrap disabled

          statusline = {
            left = [
              "mode"
              "spinner"
              "version-control"
              "file-name"
              "read-only-indicator"
              "file-modification-indicator"
            ];
            center = [ ];
            right = [
              "diagnostics"
              "selections"
              "register"
              "position"
              "file-encoding"
              "file-line-ending"
              "file-type"
            ];
            mode = {
              normal = "NORMAL";
              insert = "INSERT";
              select = "SELECT";
            };
          };
        };

        # evil-escape-key-sequence "jj": press jj in insert mode to escape.
        keys.insert.j.j = "normal_mode";
      };

      languages = {
        language-server = {
          # pyright is not in Helix's default python server list; add it so we
          # match Doom's (python +pyright).
          pyright = {
            command = "pyright-langserver";
            args = [ "--stdio" ];
          };
          # Java: front jdtls with jdtls-wrapper so go-to-definition works for
          # dependencies. jdtls returns `jdt://` URIs for compiled classes that
          # Helix cannot open; the wrapper translates them to `file://`.
          # `classFileContentsSupport` makes jdtls emit the class contents, and
          # downloadSources prefers real source jars over decompiled bytecode.
          jdtls = {
            command = "jdtls-wrapper";
            config = {
              extendedClientCapabilities.classFileContentsSupport = true;
              java.maven.downloadSources = true;
              java.eclipse.downloadSources = true;
            };
          };
        };

        language = [
          {
            name = "nix";
            language-servers = [ "nixd" "nil" ]; # prefer nixd; both installed
            formatter.command = "nixpkgs-fmt"; # repo convention (AGENTS.md)
            auto-format = true;
          }
          {
            name = "python";
            language-servers = [ "pyright" ]; # Doom: +pyright
          }
          {
            name = "java";
            language-servers = [ "jdtls" ];
            indent = {
              tab-width = 4;
              unit = "    ";
            };
          }
          {
            name = "json";
            formatter = {
              command = "prettier";
              args = [ "--parser" "json" ];
            };
            auto-format = true;
          }
          {
            name = "yaml";
            formatter = {
              command = "prettier";
              args = [ "--parser" "yaml" ];
            };
            auto-format = true;
          }
          {
            name = "markdown";
            formatter = {
              command = "prettier";
              args = [ "--parser" "markdown" ];
            };
            auto-format = true;
          }
          {
            name = "typescript";
            formatter = {
              command = "prettier";
              args = [ "--parser" "typescript" ];
            };
            auto-format = true;
          }
          {
            name = "tsx";
            formatter = {
              command = "prettier";
              args = [ "--parser" "typescript" ];
            };
            auto-format = true;
          }
          {
            name = "javascript";
            formatter = {
              command = "prettier";
              args = [ "--parser" "babel" ];
            };
            auto-format = true;
          }
          {
            name = "jsx";
            formatter = {
              command = "prettier";
              args = [ "--parser" "babel" ];
            };
            auto-format = true;
          }
        ];
      };
    };

    btop.enable = true;

    git = {
      enable = true;

      lfs.enable = true;

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
        push.default = "simple";
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
        ".claude/settings.local.json"
        ".agent-shell"
        ".pi-subagents"
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
        EDITOR = "emacsclient";
        VISUAL = "emacsclient";
        PAGER = "less";
        LESS = "-R";
        USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
        LSP_USE_PLISTS = "True";
        DIRENV_LOG_FORMAT = "";
        # SHELL = "nu";
      };

      shellAliases = {
        cat = "bat";
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
        set -g EDITOR "emacsclient"
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

      fileWidget.options = [
        "--preview '${
          lib.getExe pkgs.bat
        } --color=always --plain --line-range=:200 {}'"
      ];
      changeDirWidget.options =
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

    ghostty = {
      enable = true;
      # ghostty (source) is Linux-only in nixpkgs; ghostty-bin ships the
      # prebuilt macOS app and supports aarch64/x86_64-darwin.
      package = pkgs.ghostty-bin;
      settings = {
        theme = "Catppuccin Mocha";
        font-family = "Iosevka SS14";
        font-size = 15;
        alpha-blending = "linear-corrected";
        macos-titlebar-style = "tabs";
        macos-titlebar-proxy-icon = "hidden";
        macos-option-as-alt = true;
        keybind = [ "shift+enter=text:\\n" ];
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
      jdtls-wrapper
      claude-agent-acp
      # d2 0.7.x gates its Linux-only graphics deps (libgbm, playwright
      # browsers -> libdrm) behind `libdrm.meta.available`. Our global
      # `allowUnsupportedSystem = true` forces that to `true` on darwin, so
      # those inputs leak in and libdrm fails to build ("unsupported OS:
      # darwin"). Drop them on darwin to match upstream's intended behavior.
      (if stdenv.isDarwin then d2.overrideAttrs (_: { buildInputs = [ ]; }) else d2)
      codex-acp
      pi-acp
      herdr
      # pi-coding-agent
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
      # duckdb
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
      google-cloud-sql-proxy
      k9s
      pluto
      dockerfile-language-server
      ltex-ls
      languagetool
      nil
      nixd
      jdt-language-server
      texlab
      editorconfig-checker
      hugo
      # colima
      act
      bazelisk
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
      gh
      gnupg
      gnused
      go
      # (google-cloud-sdk.withExtraComponents
      #   [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
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
      statix
      deadnix
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
      trino-cli
      watch
      wget
      yq-go
      gatekeeper
    ] ++ lib.optionals stdenv.isDarwin [
      cocoapods
      m-cli # useful macOS CLI commands
    ];

}
