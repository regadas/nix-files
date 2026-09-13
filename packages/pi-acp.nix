{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "pi-acp";
  # Independently maintained continuation of svkozak/pi-acp. Provides stable
  # ACP v1 lifecycle/history replay, strict subprocess ownership and timeout
  # quarantine, autonomous-run prompt serialization, atomic session mapping,
  # negotiated auth/terminal behavior, and model-aware thinking levels.
  # Requires pi >= 0.80.4.
  version = "0.1.0-unstable-2026-09-11-1ae1156";
  src = pkgs.fetchFromGitHub {
    owner = "regadas";
    repo = "pi-acp";
    rev = "1ae1156771b56a960699b56ac3d3431e836cbdde";
    hash = "sha256-P+KBjYOD7hrNyMo0XYVsm+vc1LTp3ZVnFT30/nkoPAc=";
  };
  npmDepsHash = "sha256-2m3LF5XGbrlNodVGEjLTRg6najJujAe6Rrbj8/PhcMw=";
  meta = {
    description = "Independently maintained ACP adapter for pi coding agent";
    homepage = "https://github.com/regadas/pi-acp";
    license = lib.licenses.mit;
    mainProgram = "pi-acp";
  };
}
