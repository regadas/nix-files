{ config, lib, pkgs, ... }:

let
  pkgsAlt = ./pkgs;
  #openfortivpn.alt = pkgs.callPackage (pkgsAlt + "/openfortivpn") { };
in {

  nixpkgs.overlays = [
    (self: super: {
      jre = pkgs.jdk11;
      jdk = pkgs.jdk11;
    })
  ];

  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.git = {
    enable = true;
    userName = "regadas";
    userEmail = "filiperegadas@gmail.com";
    #signing = {
    #  key = "1BD40BCB6DD329D0";
    #  signByDefault = true;
    #};
    aliases = {
      s = "status";
      l =
        "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    };
    extraConfig = {
      rebase = { autoStash = true; };
      pull = { rebase = true; };
      hub = { host = "ghe.spotify.net"; };
    };
    ignores = [ ".java_version" ".metals" "metals.sbt" ".bloop" ".idea" ];
  };

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    baseIndex = 1;
    keyMode = "vi";
    shortcut = "s";

    extraConfig = ''
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


      # soften status bar color from harsh green to light gray
      set -g status-bg '#666666'
      set -g status-fg '#aaaaaa'

      # remove administrative debris (session name, hostname, time) in status bar
      set -g status-left '''
      set -g status-right '''

      # prefix -> back-one-character
      bind-key C-b send-prefix
      # prefix-2 -> forward-incremental-history-search
      bind-key C-s send-prefix -2

      # don't suspend-client
      unbind-key C-z
    '';
  };

  programs.fzf.enable = true;

  programs.zsh = {
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
  };

  #programs.zsh.initExtraBeforeCompInit =
  #      "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";

  home.packages = with pkgs; [
    #alacritty
    #dotty
    #emacs
    #openfortivpn.alt
    #vscode
    (scala.override { jre = jdk; })
    bat
    bazelisk
    curl
    delta
    direnv
    gettext
    gitAndTools.hub
    gnupg
    go
    google-cloud-sdk
    gradle
    htop
    jdk
    jq
    kubernetes
    maven
    minikube
    mosh
    nixfmt
    podman
    protobuf
    python3
    python38Packages.pip
    ripgrep
    rust-analyzer
    sbt
    scalafmt
    shellcheck
    silver-searcher
    tldr
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "regadas";
  home.homeDirectory = "/Users/regadas";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";
}
