{ config, pkgs, lib, ... }:

{
  home.stateVersion = "22.05";

  programs = {
    neovim = {
      enable = true;
    };

    helix = {
      enable = true;
      settings = {
        theme = "catppuccin_mocha";
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
          formatter = { command = "prettier"; args = [ "--parser" "json" ]; };
        }
        { name = "go"; }
        { name = "java"; }
        {
          name = "scala";
          scope = "source.scala";
          roots = [ "build.sbt" "pom.xml" ];
          file-types = [ "scala" "sbt" ];
          comment-token = "//";
          indent = { tab-width = 2; unit = "  "; };
          language-server = { command = "metals"; };
          config = { metals.ammoniteJvmProperties = [ "-Xmx1G" ]; };
        }
        {
          name = "dhall";
          scope = "source.dhall";
          roots = [ ];
          file-types = [ "dhall" ];
          comment-token = "#";
          indent = { tab-width = 2; unit = "  "; };
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

      ignores = [ ".java_version" ".metals" "metals.sbt" ".bloop" ".idea" ];

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
          name = "hydro";
          src = pkgs.fetchFromGitHub {
            owner = "jorgebucaran";
            repo = "hydro";
            rev = "a5877e9ef76b3e915c06143630bffc5ddeaba2a1";
            sha256 = "nJ8nQqaTWlISWXx5a0WeUA4+GL7Fe25658UIqKa389E=";
          };
        }
      ];
      shellInit = ''
        set -g hydro_symbol_prompt "λ"

        # set -ga PATH ${config.xdg.configHome}/bin
        # set -ga PATH $HOME/.local/bin
        # set -ga PATH /run/wrappers/bin
        # set -ga PATH $HOME/.nix-profile/bin
        # if test $KERNEL_NAME darwin
        #   set -ga PATH /opt/homebrew/opt/llvm/bin
        #   set -ga PATH /opt/homebrew/bin
        #   set -ga PATH /opt/homebrew/sbin
        # end
        # set -ga PATH /run/current-system/sw/bin
        # set -ga PATH /nix/var/nix/profiles/default/bin

        set -gx USE_GKE_GCLOUD_AUTH_PLUGIN True 
      '';
    };

    zsh = {
      enable = true;
      autocd = true;
      enableAutosuggestions = true;
      history.extended = true;
      shellAliases = {
        cat = "bat";
        git = "hub";
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

    vscode.enable = true;

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
  };

  home.packages = with pkgs;
    [
      nodePackages.dockerfile-language-server-nodejs
      ltex-ls
      languagetool
      clang
      rnix-lsp
      jdt-language-server
      texlab
      # bazel-buildtools
      editorconfig-checker
      # golangci-lint
      hugo
      colima
      # libtool
      # llvm
      act
      avro-tools
      bazel_5
      cmake
      coreutils
      curl
      delta
      deno
      dhall
      dhall-json
      dhall-lsp-server
      ditaa
      duf
      fzf
      html-tidy
      gdb
      gettext
      gh
      gitAndTools.hub
      gnupg
      gnused
      go_1_19
      (google-cloud-sdk.withExtraComponents ([ google-cloud-sdk.components.gke-gcloud-auth-plugin ]))
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
      nodejs-16_x
      operator-sdk
      pandoc
      parallel
      protobuf
      (python3.withPackages
        (ps: with ps; with python3Packages; [ pip readline sqlparse ]))
      ripgrep
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
