{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "pi-acp";
  # Independently maintained continuation of svkozak/pi-acp. Provides stable
  # ACP v1 lifecycle/history replay, strict subprocess ownership and timeout
  # quarantine, autonomous-run prompt serialization, atomic session mapping,
  # negotiated auth/terminal behavior, and model-aware thinking levels.
  # Requires pi >= 0.80.4.
  version = "0.1.0-unstable-2026-08-25-b1a6d71";
  src = pkgs.fetchFromGitHub {
    owner = "regadas";
    repo = "pi-acp";
    rev = "b1a6d712408a9a5306442a7b5325742691fbc03a";
    hash = "sha256-3mQdzMsMKua5czYembgBIsTG6rcXag+1YEtSHrTlD38=";
  };
  npmDepsHash = "sha256-yvWPSLw1N2v43/5Wb4W+k2UJhgl2Jfhdk5dBcQFqfNo=";
  meta = {
    description = "Independently maintained ACP adapter for pi coding agent";
    homepage = "https://github.com/regadas/pi-acp";
    license = lib.licenses.mit;
    mainProgram = "pi-acp";
  };
}
