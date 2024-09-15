{
  description = "Regadas system";

  inputs = {
    # Package sets
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Environment/system management
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = { self, darwin, home-manager, ... }@inputs:
    let

      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs-unstable.lib) attrValues optionalAttrs singleton;

      # Main `nix-darwin` config
      config = { pkgs, lib, ... }: {
        users.users.regadas.home = "/Users/regadas";

        nix.settings = {
          trusted-users = [ "@admin" ];
          substituters = [ "https://cache.nixos.org/" ];
          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          ];
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
        environment.systemPackages = with pkgs; [ terminal-notifier ];

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

        system.stateVersion = 5;

        # Keyboard
        system.keyboard.enableKeyMapping = true;
        system.keyboard.remapCapsLockToEscape = true;

        # Add ability to used TouchID for sudo authentication
        security.pam.enableSudoTouchIdAuth = true;
      };

      # Configuration for `nixpkgs`
      nixpkgsConfig = {
        config = {
          allowBroken = false;
          allowUnfree = true;
          allowUnsupportedSystem = true;
          permittedInsecurePackages = [ "libgcrypt-1.8.10" "nix-2.16.2" ];
        };

        overlays = attrValues self.overlays ++ singleton (
          # Sub in x86 version of packages that don't build on Apple Silicon yet
          final: prev:
          (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
            inherit (final.pkgs-x86) nix-index niv purescript bazel;
          }));
      };

      # my `home-manager` module
      homeManagerConfig = {
        nixpkgs = nixpkgsConfig;
        # `home-manager` config
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.regadas = import ./home.nix;
      };
    in {
      # My `nix-darwin` configs
      darwinConfigurations = {
        Filipes-MacBook-Air = darwinSystem {
          system = "x86_64-darwin";
          modules = [
            config
            home-manager.darwinModules.home-manager
            homeManagerConfig
          ];
        };
        MacPro = darwinSystem {
          system = "x86_64-darwin";
          modules = [
            config
            home-manager.darwinModules.home-manager
            homeManagerConfig
          ];
        };
        PN402PJ2C6 = darwinSystem {
          system = "aarch64-darwin";
          modules = [
            config
            home-manager.darwinModules.home-manager
            homeManagerConfig
          ];
        };
      };

      # Overlays --------------------------------------------------------------- {{{

      overlays = {
        # Overlays to add various packages into package set
        pkgs-unstable = final: prev: {
          unstable = import inputs.nixpkgs-unstable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };

        # Overlay useful on Macs with Apple Silicon
        apple-silicon = final: prev:
          optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
            # Add access to x86 packages system is running Apple Silicon
            pkgs-x86 = import inputs.nixpkgs-unstable {
              system = "x86_64-darwin";
              inherit (nixpkgsConfig) config;
            };
          };
      };

    };
}
