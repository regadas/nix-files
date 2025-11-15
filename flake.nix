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
      url = "github:nix-community/home-manager/master";
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
      
      # Helper function for standalone home-manager configs
      mkHomeConfig = { system, username ? "regadas" }: 
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs-unstable.legacyPackages.${system};
          modules = [
            ./modules/shared/home-manager.nix
            {
              home = {
                username = username;
                homeDirectory = "/Users/${username}";
                # Enable this line if you want very precise control over state management:
                # stateVersion = "24.11";
              };
            }
          ];
          extraSpecialArgs = inputs // { inherit system; };
        };
    in {
      # My `nix-darwin` configs - integrated mode
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

        L2TX7X6LDP = mkDarwinConfig {
          system = "aarch64-darwin";
          hostname = "L2TX7X6LDP";
        };
      };
      
      # Standalone home-manager configurations - can be used with:
      # home-manager switch --flake .#regadas-x86_64-darwin
      homeConfigurations = {
        "regadas-x86_64-darwin" = mkHomeConfig {
          system = "x86_64-darwin";
        };
        
        "regadas-aarch64-darwin" = mkHomeConfig {
          system = "aarch64-darwin";
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
