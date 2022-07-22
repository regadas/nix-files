{ config, pkgs, lib, ... }:

{
  home.stateVersion = "22.05";

  nixpkgs.overlays = [
    #(self: super: { vscode = pkgsUnstable.vscode; })
    # (self: super: {
    #   jre = pkgs.graalvm11-ce;
    #   jdk = pkgs.graalvm11-ce;
    # })
  ];

  # https://github.com/malob/nixpkgs/blob/master/home/default.nix

  programs = {
    htop.enable = true;

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      plugins = with pkgs; [
        vimPlugins.ctrlp
        vimPlugins.vim-airline
        vimPlugins.vim-airline-themes
        vimPlugins.vim-eunuch
        vimPlugins.vim-gitgutter
        vimPlugins.vim-markdown
        vimPlugins.vim-nix
        vimPlugins.nvim-lspconfig
        vimPlugins.telescope-nvim
      ];
    };

    git = {
      enable = true;
      userName = "regadas";
      userEmail = "oss@regadas.email";

      signing = {
        key = "2572CF0C";
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
    };

    tmux = {
      enable = true;
      terminal = "screen-256color";
      baseIndex = 1;
      keyMode = "vi";
      shortcut = "s";
      plugins = with pkgs.tmuxPlugins; [
        sensible
        yank
        {
          plugin = dracula;
          extraConfig = ''
            set -g @dracula-plugins "cpu-usage gpu-usage ram-usage"
            set -g @dracula-show-battery false
            set -g @dracula-show-powerline false
            set -g @dracula-refresh-rate 10
            # set -g @dracula-show-left-icon window
          '';
        }
      ];

      extraConfig = ''
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
        export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=cyan,bg=bold,underline"
        export PATH=$PATH:/opt/homebrew/bin:$HOME/go/bin
      '';
    };

    # broot.enable = true;

    bat = {
      enable = true;
      config.theme = "ansi";
    };

    fzf.enable = true;

    #alacritty.enable = true;
    #vscode.enable = true;
    java = {
      enable = true;
      package = pkgs.graalvm11-ce;
    };

    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    # texlive = {
    #   enable = true;
    #   extraPackages = tpkgs: { inherit (tpkgs) scheme-full; };
    # };
    exa = {
      enable = true;
      enableAliases = true;
    };
  };

  home.packages = with pkgs;
    [
      # bazel-buildtools
      # editorconfig-checker
      # golangci-lint
      # hugo
      # podman
      # emacsUnstable
      # libtool
      # llvm
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
      gdb
      gettext
      gh
      gitAndTools.hub
      gnupg
      gnused
      go_1_18
      google-cloud-sdk
      gopls
      graalvm11-ce
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
      nodePackages.yarn
      nodePackages.yo
      nodejs-16_x
      operator-sdk
      pandoc
      parallel
      protobuf
      (python3.withPackages
        (ps: with ps; with python3Packages; [ pip readline ]))
      ripgrep
      ripgrep
      rustup
      (sbt.override { jre = graalvm11-ce; })
      (scala.override { jre = graalvm11-ce; })
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

