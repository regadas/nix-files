{ pkgs, lib, ... }:

{
  # Nix configuration ------------------------------------------------------------------------------

  nix.settings = {
    trusted-users = [ "@admin" ];
    substituters = [ "https://cache.nixos.org/" ];
    trusted-public-keys =
      [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
  };
  nix.configureBuildUsers = true;

  # Enable experimental nix command and flakes
  # nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  services.yabai.enable = true;
  services.yabai.package = pkgs.yabai;
  services.skhd.enable = true;

  launchd.user.agents.skhd.serviceConfig = {
    StandardOutPath = "/tmp/skhd.out.log";
    StandardErrorPath = "/tmp/skhd.err.log";
  };
  launchd.user.agents.yabai.serviceConfig = {
    StandardOutPath = "/tmp/yabai.out.log";
    StandardErrorPath = "/tmp/yabai.err.log";
  };

  # Apps
  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = with pkgs; [
    vscode
    alacritty
    terminal-notifier
  ];

  programs.nix-index.enable = true;

  # Fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    recursive
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    iosevka-bin
    font-awesome
  ];

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

}

