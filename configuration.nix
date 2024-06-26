{ pkgs, lib, ... }:

{
  # Nix configuration ------------------------------------------------------------------------------
  users.users.regadas.home = "/Users/regadas";

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

  programs.fish.enable = true;

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
    terminal-notifier
  ];

  programs.nix-index.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    recursive
    nerdfonts
    iosevka-bin
    font-awesome
    cascadia-code
    fira-code
    jetbrains-mono
    ibm-plex
    intel-one-mono
  ];

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

}
