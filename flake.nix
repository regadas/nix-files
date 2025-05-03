{
  description = "Regadas system";

  inputs = {
    # Package sets
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    # For multi-platform support
    flake-utils.url = "github:numtide/flake-utils";
    
    # Environment/system management
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, darwin, home-manager, flake-utils, nixpkgs, nixpkgs-unstable, ... }@inputs:
    let 
      inherit (darwin.lib) darwinSystem;
      
      # Define supported systems
      darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];
      
      # Helper function to create Darwin configurations
      mkDarwinConfig = { system, hostname, modules ? [] }: darwinSystem {
        inherit system;
        specialArgs = inputs // { inherit hostname; };
        modules = [ 
          home-manager.darwinModules.home-manager
          ./hosts/darwin
        ] ++ modules;
      };
    in {
      # My `nix-darwin` configs
      darwinConfigurations = {
        # x86_64 systems
        Filipes-MacBook-Air = mkDarwinConfig {
          system = "x86_64-darwin";
          hostname = "Filipes-MacBook-Air";
        };
        
        MacPro = mkDarwinConfig {
          system = "x86_64-darwin";
          hostname = "MacPro";
        };
        
        # aarch64 system
        PN402PJ2C6 = mkDarwinConfig {
          system = "aarch64-darwin";
          hostname = "PN402PJ2C6";
        };
      };
      
      # Add flake-utils supported outputs
    } // flake-utils.lib.eachSystem darwinSystems (system: {
      # System-specific packages and development shells could go here
      # This enables `nix shell` and `nix build` to work across platforms
      packages = {
        # Example: default = nixpkgs.legacyPackages.${system}.hello;
      };
      
      # Development shell with tools common across all your systems
      devShells.default = nixpkgs.legacyPackages.${system}.mkShell {
        buildInputs = with nixpkgs.legacyPackages.${system}; [
          nixpkgs-fmt
          nixfmt-classic
        ];
      };
    });
}
