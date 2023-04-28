{ config, pkgs, lib, ... }:

{
  home.stateVersion = "22.11";

  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      withNodeJs = true;
    };

    helix = {
      enable = true;
      settings = {
        theme = "rose_pine";
        editor = {
          line-number = "relative";
          mouse = true;
          lsp.display-messages = true;
          cursorline = true;
          indent-guides.render = true;
          color-modes = true;
        };
        keys.normal = { space.space = "file_picker"; };
        editor.cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        editor.file-picker = { hidden = false; };
      };
      languages = [
        { name = "sql"; }
        { name = "latex"; }
        { name = "html"; }
        { name = "bash"; }
        { name = "toml"; }
        { name = "nix"; }
        { name = "markdown"; }
        { name = "yaml"; }
        { name = "dockerfile"; }
        {
          name = "json";
          formatter = {
            command = "prettier";
            args = [ "--parser" "json" ];
          };
        }
        { name = "go"; }
        { name = "java"; }
        {
          name = "scala";
          scope = "source.scala";
          roots = [ "build.sbt" "pom.xml" ];
          file-types = [ "scala" "sbt" ];
          comment-token = "//";
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          language-server = { command = "metals"; };
          config = { metals.ammoniteJvmProperties = [ "-Xmx1G" ]; };
        }
        {
          name = "dhall";
          scope = "source.dhall";
          roots = [ ];
          file-types = [ "dhall" ];
          comment-token = "#";
          indent = {
            tab-width = 2;
            unit = "  ";
          };
          language-server = { command = "dhall-lsp-server"; };
        }
        { name = "rust"; }
        { name = "python"; }
        { name = "javascript"; }
        { name = "typescript"; }
      ];
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

      ignores = [ ".java_version" ".metals" "metals.sbt" ".bloop" ".idea" ".DS_Store" ];

      delta.enable = true;
    };

    tmux = {
      enable = true;
      terminal = "xterm-256color";
      baseIndex = 1;
      keyMode = "vi";
      shortcut = "s";
      plugins = with pkgs.tmuxPlugins; [
        sensible
        yank
        {
          plugin = dracula;
          extraConfig = ''
            set -g @dracula-plugins "cpu-usage ram-usage"
            set -g @dracula-show-battery false
            set -g @dracula-show-powerline true
            set -g @dracula-refresh-rate 10
            # set -g @dracula-show-left-icon window
          '';
        }
      ];

      extraConfig = ''
        set -ga terminal-overrides ",xterm-256color*:Tc"
        set -g mouse on

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
            rev = "f3a547b0239cf8529d35c1922dd242bacf751d3b";
            sha256 = "sha256-3mFlFiqGfQ+GfNshwKfhQ39AuNMdt8Nv2Vgb7bBV7L4=";
          };
        }
        {
          name = "pure";
          src = pkgs.fetchFromGitHub {
            owner = "pure-fish";
            repo = "pure";
            rev = "1c1f5b4d1d3fa36162186aa0aac295f59efe22bc";
            sha256 = "sha256-ec1ZAjIGn6xYMh+3kyQP8HYUti8iFXsyzTJ19tU8T84=";
          };
        }
      ];
      shellInit = ''
        set -U fish_greeting
        set -g hydro_symbol_prompt "λ"

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
      '';

      shellAliases = {
        cat = "bat";
        git = "hub";
        k = "kubectl";
      };
    };

    zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      enableAutosuggestions = true;
      history.extended = true;
      shellAliases = {
        cat = "bat";
        git = "hub";
        k = "kubectl";
      };
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = lib.cleanSource ./config/p10k;
          file = "p10k.zsh";
        }
      ];
      initExtra = ''
        export USE_GKE_GCLOUD_AUTH_PLUGIN=True
        export LSP_USE_PLISTS=true
        export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=cyan,bg=bold,underline"
        export PATH=$PATH:/opt/homebrew/bin:$HOME/go/bin
      '';
    };

    broot.enable = true;

    bat = {
      enable = true;
      config.theme = "ansi";
    };

    fzf.enable = true;

    alacritty.enable = true;

    vscode = {
      enable = true;
    };

    java = {
      enable = true;
      package = pkgs.jdk;
    };

    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    texlive = {
      enable = true;
      extraPackages = tpkgs: { inherit (tpkgs) scheme-full; };
    };

    exa = {
      enable = true;
      enableAliases = true;
    };

    zoxide.enable = true;
  };

  home.packages = with pkgs;
    [
      grpcurl
      git-absorb
      fx
      krew
      marksman
      emacs
      httpie
      obsidian
      d2
      cloud-sql-proxy
      k9s
      pluto
      nodePackages.dockerfile-language-server-nodejs
      ltex-ls
      languagetool
      rnix-lsp
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
      gdb
      gettext
      gh
      gitAndTools.hub
      gnupg
      gnused
      go
      (google-cloud-sdk.withExtraComponents
        ([ google-cloud-sdk.components.gke-gcloud-auth-plugin ]))
      gopls
      jdk
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
      mosh
      nixfmt
      nixpkgs-fmt
      nodePackages.generator-code
      nodePackages.mermaid-cli
      nodePackages.prettier
      nodePackages.sql-formatter
      nodePackages.typescript
      nodePackages.typescript-language-server
      nodePackages.yaml-language-server
      nodePackages.vscode-json-languageserver
      nodePackages.yarn
      nodePackages.yo
      nodePackages.pyright
      nodePackages_latest.bash-language-server
      nodePackages_latest.markdownlint-cli2
      nodejs-16_x
      operator-sdk
      pandoc
      parallel
      protobuf
      (python3.withPackages
        (ps: with ps; with python3Packages; [
          pip
          readline
          sqlparse
          python-lsp-server
        ]))
      ripgrep
      rustup
      sbt
      scala
      scala-cli
      scalafmt
      shellcheck
      silver-searcher
      tldr
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
