{ config, lib, pkgs, ... }:

{
  imports = [ <home-manager/nix-darwin> ];
  # imports = [ ~/.config/nixpkgs/darwin/local-configuration.nix ];

  # system.patches = [ ./pam.patch ];
  system.activationScripts.applications.text = pkgs.lib.mkForce (''
      echo "setting up ~/Applications/Nix..."
      rm -rf ~/Applications
      mkdir -p ~/Applications
      chown regadas ~/Applications
      find ${config.system.build.applications}/Applications -maxdepth 1 -type l | while read f; do
        src=$(/usr/bin/stat -f%Y "$f")
        appname=$(basename "$src")
        osascript -e "tell app \"Finder\" to make alias file at POSIX file \"/Users/regadas/Applications/\" to POSIX file \"$src\" with properties {name: \"$appname\"}";
    done
  '');

  services.nix-daemon.enable = true;

  services.yabai.enable = true;
  services.yabai.package = pkgs.yabai;
  services.skhd.enable = true;

  # programs.gnupg.agent.enable = true;
  # programs.gnupg.agent.enableSSHSupport = true;

  # Dotfiles.

  nixpkgs.config.allowUnfree = true;

  users.users.regadas.name = "regadas";
  users.users.regadas.home = "/Users/regadas";

  programs.zsh = {
    enable = true;
    enableCompletion = false;
  };
  environment.systemPackages = with pkgs; [ alacritty vscode ];

  home-manager.users.regadas = (import ~/.nixpkgs/home.nix);
}
