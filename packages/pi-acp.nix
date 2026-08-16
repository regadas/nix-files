{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "pi-acp";
  # Independently maintained continuation of svkozak/pi-acp. Provides stable
  # ACP v1 lifecycle/history replay, strict subprocess ownership and timeout
  # quarantine, autonomous-run prompt serialization, atomic session mapping,
  # negotiated auth/terminal behavior, and model-aware thinking levels.
  # Requires pi >= 0.80.4.
  version = "0.1.0-unstable-2026-08-16-f2f0f51";
  src = pkgs.fetchFromGitHub {
    owner = "regadas";
    repo = "pi-acp";
    rev = "f2f0f51f46bef170b7b7987462039f534c10de45";
    hash = "sha256-rRGGarK5DqUR2wWy6/sxOWpv0Yg79nMfFEJI/ERFXc8=";
  };
  npmDepsHash = "sha256-o/PZJPyWSlIwTCCvFgvFgx8EjsTH+dW2pK6MOEgoIbM=";
  meta = {
    description = "Independently maintained ACP adapter for pi coding agent";
    homepage = "https://github.com/regadas/pi-acp";
    license = lib.licenses.mit;
    mainProgram = "pi-acp";
  };
}
