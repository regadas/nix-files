{ lib, pkgs, ... }: {

  nix.settings = {
    # Trust users in admin group to manage Nix
    trusted-users = [ "@admin" ];
    
    # Substituters (binary caches)
    substituters = [ 
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://nixpkgs-update.cachix.org"
      "https://iohk.cachix.org"
      "https://cache.iog.io"
      "https://devenv.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-update.cachix.org-1:6y6Z2JdoL3APdu6/+Iy8eZX2ajf09e4EE9SnxSML1W8="
      "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
    
    # Performance optimizations
    keep-outputs = true;             # Keep build dependencies to avoid rebuilds
    keep-derivations = true;         # Keep derivation files for faster rebuilds
    fallback = true;                 # Build from source if binary fetch fails
    max-jobs = "auto";               # Use all available cores for building
    cores = 0;                       # Use all available cores per build job
  };

  # Enable experimental nix command and flakes
  # nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    # Speed up downloads by using multiple connections
    http-connections = 50
    # Use binary cache even if we have a result locally
    narinfo-cache-negative-ttl = 0
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  programs.fish.enable = true;

  programs.nix-index.enable = true;
  
  # Garbage collection to keep the Nix store efficient
  nix.gc = {
    automatic = true;
    interval = { Day = 7; };  # Run weekly
    options = "--delete-older-than 30d";  # Delete generations older than 30 days
  };
  
  # Store optimization
  nix.optimise = {
    automatic = true;
    interval = { Day = 7; };  # Run weekly
  };

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

  system.primaryUser = "regadas";

  ids.gids.nixbld = 350;

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

  # `home-manager` config
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.regadas = import ./home-manager.nix;
  };
}
