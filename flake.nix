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
    let inherit (darwin.lib) darwinSystem;
    in {
      # My `nix-darwin` configs
      darwinConfigurations = {
        Filipes-MacBook-Air = darwinSystem {
          system = "x86_64-darwin";
          specialArgs = inputs;
          modules = [ home-manager.darwinModules.home-manager ./hosts/darwin ];
        };
        MacPro = darwinSystem {
          system = "x86_64-darwin";
          specialArgs = inputs;
          modules = [ home-manager.darwinModules.home-manager ./hosts/darwin ];
        };
        PN402PJ2C6 = darwinSystem {
          system = "aarch64-darwin";
          specialArgs = inputs;
          modules = [ home-manager.darwinModules.home-manager ./hosts/darwin ];
        };
      };
    };
}
