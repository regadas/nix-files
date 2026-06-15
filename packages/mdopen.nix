{ pkgs, lib, ... }:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "mdopen";
  version = "0.6.0";
  src = pkgs.fetchFromGitHub {
    owner = "immanelg";
    repo = "mdopen";
    rev = "6ea7b7b904ce1b7885f8bfddceb47d571b68ccd5";
    hash = "sha256-1aOJE/R+6opDaj+K3IH2e7r1B5THoabXAFt0QGK8BFE=";
  };
  cargoHash = "sha256-1eBppQsvwXUPQlQ01urKAtBkhZo1OkKCxRaqd/LicAo=";
  doCheck = false;
  meta = {
    description = "Preview markdown files in a browser";
    homepage = "https://github.com/immanelg/mdopen";
    license = lib.licenses.bsd3;
  };
}
