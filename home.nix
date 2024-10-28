{ config, pkgs, lib, ... }:

{
  home.stateVersion = "23.05";

  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      withNodeJs = true;
    };

    htop.enable = true;

    git = {
      enable = true;
      userName = "regadas";
      userEmail = "oss@regadas.email";

      signing = {
        key = "55A043A0";
        signByDefault = true;
      };

      aliases = {
        s = "status";
        l =
          "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };

      extraConfig = {
        color.ui = true;
        branch.autosetuprebase = "always";
        rebase.autoStash = true;
        pull.rebase = true;
        init.defaultBranch = "main";
        push.default = "tracking";
        hub.host = "ghe.spotify.net";
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
      ];

      delta.enable = true;
    };

    tmux = {
      enable = true;
      terminal = "xterm-256color";
      baseIndex = 1;
      keyMode = "vi";
      shortcut = "s";
      plugins = with pkgs.tmuxPlugins; [ sensible yank catppuccin ];

      extraConfig = ''
        set -ga terminal-overrides ",xterm-256color*:Tc"
        set -g mouse on
        set -sg escape-time 100

        # act like vim
        bind-key h select-pane -L
        bind-key j select-pane -D
        bind-key k select-pane -U
        bind-key l select-pane -R
        bind-key -r C-h select-window -t :-
        bind-key -r C-l select-window -t :+

        # set -g prefix2 C-s
        # renumber windows sequentially after closing any of them
        set -g renumber-windows on

        # prefix -> back-one-character
        bind-key C-b send-prefix
        # prefix-2 -> forward-incremental-history-search
        bind-key C-s send-prefix -2

        # don't suspend-client
        unbind-key C-z
      '';
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
          name = "tide";
          src = pkgs.fetchFromGitHub {
            owner = "IlanCosman";
            repo = "tide";
            rev = "812fb9b6d6e0d8c2b575d3fe0c7b31a796214bc4";
            sha256 = "sha256-cGfvWi9r3rA9QFBewW7A+LXS2DavSUtWzk9/NbxEV48=";
          };
        }
      ];
      shellInit = ''
        set -g EDITOR "nvim"
        set -U fish_greeting
        set -g hydro_symbol_prompt "λ"
        set -g tide_right_prompt_items

        # set -ga PATH ${config.xdg.configHome}/bin
        fish_add_path -gm $HOME/.local/bin
        fish_add_path -gm $HOME/go/bin
        fish_add_path -gm $HOME/.krew/bin

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

      fileWidgetOptions = [
        "--preview '${
          lib.getExe pkgs.bat
        } --color=always --plain --line-range=:200 {}'"
      ];
      changeDirWidgetOptions =
        [ "--preview '${lib.getExe pkgs.tree}  -C {} | head -200'" ];
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
          normal = { family = "JetBrainsMono Nerd Font"; };
          bold = {
            family = "JetBrainsMono Nerd Font";
            style = "bold";
          };
          italic = {
            family = "JetBrainsMono Nerd Font";
            style = "italic";
          };
        };
      };
    };

    vscode = { enable = true; };

    java = {
      enable = true;
      package = pkgs.jdk21;
    };

    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    texlive = {
      enable = true;
      extraPackages = tpkgs: { inherit (tpkgs) scheme-full; };
    };

    lsd = {
      enable = true;
      enableAliases = true;
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
  };

  home.packages = with pkgs;
    [
      ffmpegthumbnailer
      tree
      ffmpeg
      gh-dash
      ookla-speedtest
      ruby-lsp
      devenv
      duckdb
      fd
      lazygit
      ollama
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
      obsidian
      d2
      google-cloud-sql-proxy
      k9s
      pluto
      nodePackages.dockerfile-language-server-nodejs
      ltex-ls
      languagetool
      nixd
      jdt-language-server
      texlab
      editorconfig-checker
      hugo
      colima
      act
      avro-tools
      bazel_5
      bazel-buildtools
      coreutils
      curl
      delta
      deno
      dhall
      dhall-json
      dhall-lsp-server
      ditaa
      duf
      html-tidy
      gettext
      gh
      gitAndTools.hub
      gnupg
      gnused
      go
      (google-cloud-sdk.withExtraComponents
        [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
      gopls
      jdk21
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
      nixfmt-classic
      nixpkgs-fmt
      mermaid-cli
      nodePackages_latest.prettier
      nodePackages_latest.sql-formatter
      typescript
      nodePackages_latest.typescript-language-server
      yaml-language-server
      nodePackages_latest.vscode-json-languageserver
      yarn
      yo
      pyright
      bash-language-server
      markdownlint-cli2
      nodejs
      operator-sdk
      pandoc
      parallel
      protobuf
      ruby
      (python3.withPackages (ps:
        with ps;
        with python3Packages; [
          pip
          readline
          sqlparse
          python-lsp-server
          grip
        ]))
      ripgrep
      rustup
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
