{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "pi-acp";
  # Independently maintained continuation of svkozak/pi-acp. Provides stable
  # ACP v1 lifecycle/history replay, strict subprocess ownership and timeout
  # quarantine, autonomous-run prompt serialization, atomic session mapping,
  # negotiated auth/terminal behavior, and model-aware thinking levels.
  # Requires pi >= 0.80.4.
  version = "0.1.0-unstable-2026-08-16-a790a02";
  src = pkgs.fetchFromGitHub {
    owner = "regadas";
    repo = "pi-acp";
    rev = "a790a026a179185107c231a3021b0926c0deb257";
    hash = "sha256-Zw9MHyjf2V+WiH7pQqgVv/F6A4hPftRqktCDBW6Uhvw=";
  };
  npmDepsHash = "sha256-yvWPSLw1N2v43/5Wb4W+k2UJhgl2Jfhdk5dBcQFqfNo=";
  meta = {
    description = "Independently maintained ACP adapter for pi coding agent";
    homepage = "https://github.com/regadas/pi-acp";
    license = lib.licenses.mit;
    mainProgram = "pi-acp";
  };
}
