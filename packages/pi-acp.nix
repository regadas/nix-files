{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "pi-acp";
  version = "0.0.28";
  src = pkgs.fetchFromGitHub {
    owner = "svkozak";
    repo = "pi-acp";
    rev = "v${version}";
    hash = "sha256-Hv5AeNJTnfXAowQFSWAWzKk/03G/H2JVTS7KLafpRGg=";
  };
  npmDepsHash = "sha256-/k//AikjjJNUkA38O/gXh4yEk/E52+ue6BI/SwRCa8k=";
  meta = {
    description = "ACP adapter for pi coding agent";
    homepage = "https://github.com/svkozak/pi-acp";
    license = lib.licenses.mit;
    mainProgram = "pi-acp";
  };
}
