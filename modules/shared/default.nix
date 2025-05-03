{ lib, pkgs, ... }: {

  nix.settings = {
    # Trust users in admin group to manage Nix
    trusted-users = [ "@admin" ];
    
    # Substituters (binary caches)
    substituters = [ 
      "https://cache.nixos.org/" 
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
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

  # `home-manager` config
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.regadas = import ./home-manager.nix;
  };
}
