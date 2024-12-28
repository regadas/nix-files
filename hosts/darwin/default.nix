{ pkgs, ... }: {
  # nixpkgs.overlays = attrValues self.overlays ++ singleton (
  #   # Sub in x86 version of packages that don't build on Apple Silicon yet
  #   final: prev:
  #   (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
  #     inherit (final.pkgs-x86) nix-index niv purescript bazel;
  #   }));

  users.users.regadas.home = "/Users/regadas";

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

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
      cleanup = "uninstall";
      upgrade = true;
    };
    brews = [
      "zlib"
      {
        name = "emacs-plus@30";
        args = [ "with-xwidgets" "with-native-comp" "with-imagemagick" ];
      }
    ];
    taps = [ "d12frosted/emacs-plus" ];
  };

}
