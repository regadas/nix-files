{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "pi-acp";
  # Independently maintained continuation of svkozak/pi-acp. Provides stable
  # ACP v1 lifecycle/history replay, strict subprocess ownership and timeout
  # quarantine, autonomous-run prompt serialization, atomic session mapping,
  # negotiated auth/terminal behavior, and model-aware thinking levels.
  # Requires pi >= 0.80.4.
  version = "0.1.0-unstable-2026-08-16-6612cf9";
  src = pkgs.fetchFromGitHub {
    owner = "regadas";
    repo = "pi-acp";
    rev = "6612cf98afbce31f34f612617b95f9669e13e79c";
    hash = "sha256-0+yN/K/hokv9GTEhGA6Adr7oRI7j/Gjv3tkEyaKF718=";
  };
  npmDepsHash = "sha256-o/PZJPyWSlIwTCCvFgvFgx8EjsTH+dW2pK6MOEgoIbM=";
  meta = {
    description = "Independently maintained ACP adapter for pi coding agent";
    homepage = "https://github.com/regadas/pi-acp";
    license = lib.licenses.mit;
    mainProgram = "pi-acp";
  };
}
