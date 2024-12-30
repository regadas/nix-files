{ }: {

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
