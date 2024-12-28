{
  description = "Regadas system";

  inputs = {
    # Package sets
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Environment/system management
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = { darwin, home-manager, ... }@inputs:
    let

      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs-unstable.lib) optionalAttrs;

      # Main `nix-darwin` config
      config = { pkgs, lib, ... }: {

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

        programs.nix-index.enable = true;

        # Fonts
        fonts.packages = with pkgs; [
          recursive
          nerd-fonts.iosevka
          nerd-fonts.jetbrains-mono
          nerd-fonts.fira-code
          nerd-fonts.blex-mono
          iosevka-bin
          font-awesome
          cascadia-code
          fira-code
          jetbrains-mono
          ibm-plex
          intel-one-mono
        ];

        system.stateVersion = 5;

        ids.gids.nixbld = 30000;

        # Keyboard
        system.keyboard.enableKeyMapping = true;
        system.keyboard.remapCapsLockToEscape = true;

        nixpkgs = {
          config = {
            allowBroken = false;
            allowUnfree = true;
            allowUnsupportedSystem = true;
          };
        };
      };

      homeManagerConfig = {
        # `home-manager` config
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.regadas = import ./home.nix;
        };
      };

    in {
      # My `nix-darwin` configs
      darwinConfigurations = {
        Filipes-MacBook-Air = darwinSystem {
          system = "x86_64-darwin";
          specialArgs = inputs;
          modules = [
            config
            home-manager.darwinModules.home-manager
            homeManagerConfig
            ./hosts/darwin
          ];
        };
        MacPro = darwinSystem {
          system = "x86_64-darwin";
          specialArgs = inputs;
          modules = [
            config
            home-manager.darwinModules.home-manager
            homeManagerConfig
            ./hosts/darwin
          ];
        };
        PN402PJ2C6 = darwinSystem {
          system = "aarch64-darwin";
          specialArgs = inputs;
          modules = [
            config
            home-manager.darwinModules.home-manager
            homeManagerConfig
            ./hosts/darwin
          ];
        };
      };

      # Overlays --------------------------------------------------------------- {{{

      overlays = {
        # Overlays to add various packages into package set
        pkgs-unstable = final: prev: {
          unstable = import inputs.nixpkgs-unstable {
            inherit (prev.stdenv) system;
            inherit config;
          };
        };

        # Overlay useful on Macs with Apple Silicon
        apple-silicon = final: prev:
          optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
            # Add access to x86 packages system is running Apple Silicon
            pkgs-x86 = import inputs.nixpkgs-unstable {
              system = "x86_64-darwin";
              inherit config;
            };
          };
      };

    };
}
