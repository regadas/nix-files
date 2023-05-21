{
  description = "Regadas system";

  inputs = {
    # Package sets
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Environment/system management
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # Other sources
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-darwin.url = "github:regadas/emacs";

  };

  outputs = { self, darwin, nixpkgs, home-manager, emacs-overlay, emacs-darwin, ... }@inputs:
    let

      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs-unstable.lib)
        attrValues makeOverridable optionalAttrs singleton;

      # Configuration for `nixpkgs`
      nixpkgsConfig = {

        config = {
          allowBroken = true;
          allowUnfree = true;
          allowUnsupportedSystem = true;
        };

        overlays = attrValues self.overlays ++ [
          (import (builtins.fetchGit {
            url = "https://github.com/nix-community/emacs-overlay.git";
            ref = "master";
            rev =
              "612fc9ab31d2cdfe6ca99d606c49072d90c4e42b"; # change the revision
          }))
          emacs-darwin.overlay
        ] ++ singleton (
          # Sub in x86 version of packages that don't build on Apple Silicon yet
          final: prev:
            (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
              inherit (final.pkgs-x86)
                nix-index niv purescript bazel;
            })
        );
      };
    in
    {
      # My `nix-darwin` configs

      darwinConfigurations = rec {
        MacPro = darwinSystem {
          system = "x86_64-darwin";
          modules = [
            # Main `nix-darwin` config
            ./configuration.nix
            # `home-manager` module
            home-manager.darwinModules.home-manager
            {
              nixpkgs = nixpkgsConfig;
              # `home-manager` config
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.regadas = import ./home.nix;
            }
          ];
        };
        PN402PJ2C6 = darwinSystem {
          system = "aarch64-darwin";
          modules = [
            # Main `nix-darwin` config
            ./configuration.nix
            # `home-manager` module
            home-manager.darwinModules.home-manager
            {
              nixpkgs = nixpkgsConfig;
              # `home-manager` config
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.regadas = import ./home.nix;
            }
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
