{ config, lib, pkgs, ... }:

{
  imports = [ <home-manager/nix-darwin> ];
  # imports = [ ~/.config/nixpkgs/darwin/local-configuration.nix ];

  # system.patches = [ ./pam.patch ];

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

  programs.zsh.enable = true;

  home-manager.users.regadas = (import ~/.nixpkgs/home.nix);
}
