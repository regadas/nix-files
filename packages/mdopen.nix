{ pkgs, lib, ... }:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "mdopen";
  version = "0.5.0";
  src = pkgs.fetchFromGitHub {
    owner = "immanelg";
    repo = "mdopen";
    rev = "3858a4d2222ac789b168729ac1ae7b726342526e";
    hash = "sha256-a0yhi0oRQTl3lIAkzar7hgCYM6gDX6YQ9Oc18/jYlwg=";
  };
  cargoHash = "sha256-fr7gd61NxKjuYUFePPx4qil2owzfCF6kDMlOga4AfCE=";
  doCheck = false;
  meta = {
    description = "Preview markdown files in a browser";
    homepage = "https://github.com/immanelg/mdopen";
    license = lib.licenses.bsd3;
  };
}
