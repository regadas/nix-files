{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "pi-acp";
  # Independently maintained continuation of svkozak/pi-acp. Provides stable
  # ACP v1 lifecycle/history replay, strict subprocess ownership and timeout
  # quarantine, autonomous-run prompt serialization, atomic session mapping,
  # negotiated auth/terminal behavior, and model-aware thinking levels.
  # Requires pi >= 0.80.4.
  version = "0.1.0-unstable-2026-07-23-d71af10";
  src = pkgs.fetchFromGitHub {
    owner = "regadas";
    repo = "pi-acp";
    rev = "d71af10d80bcfc46e20a077aa6c6a575b47e1343";
    hash = "sha256-24GAHXaui37Eiy8R8Cv8vZ0yeXNJHIrsbeoypmLUuCk=";
  };
  npmDepsHash = "sha256-o/PZJPyWSlIwTCCvFgvFgx8EjsTH+dW2pK6MOEgoIbM=";
  meta = {
    description = "Independently maintained ACP adapter for pi coding agent";
    homepage = "https://github.com/regadas/pi-acp";
    license = lib.licenses.mit;
    mainProgram = "pi-acp";
  };
}
