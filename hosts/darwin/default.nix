{ pkgs, hostname, ... }: {

  imports = [ ../../modules/shared ];

  users.users.regadas.home = "/Users/regadas";

  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  # nix-darwin (latest master, 2026-06-18) still calls `nixos-render-docs
  # manual html --toc-depth`, but nixpkgs removed that flag on 2026-07-02
  # (use --sidebar-depth). Disable the generated manual/help until nix-darwin
  # catches up; re-enable once upstream adopts the new flag.
  documentation.enable = false;
  # darwin-uninstaller builds its own isolated nix-darwin system with
  # documentation defaulted on, so the setting above can't reach it and it
  # hits the same --toc-depth failure. Disable it too (rarely-used tool).
  system.tools.darwin-uninstaller.enable = false;

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
  environment.systemPackages = with pkgs; [ terminal-notifier ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "none";
      upgrade = true;
    };
    brews = [
      "gcc"
      "libgccjit"
      "zlib"
    ];
    taps = [ "d12frosted/emacs-plus" ];
  };

}
