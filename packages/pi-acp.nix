{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "pi-acp";
  # Independently maintained continuation of svkozak/pi-acp. Provides stable
  # ACP v1 lifecycle/history replay, strict subprocess ownership and timeout
  # quarantine, atomic session mapping, negotiated auth/terminal behavior, and
  # model-aware thinking levels. Requires pi >= 0.80.4.
  version = "0.1.0";
  src = pkgs.fetchFromGitHub {
    owner = "regadas";
    repo = "pi-acp";
    rev = "649ff62ed09bc93e26867c9d189aecb175d72e14";
    hash = "sha256-Wjjxbp++ek0+D79oDkfjxhzT+MVz9nx/N3f3L9yGOrI=";
  };
  npmDepsHash = "sha256-o/PZJPyWSlIwTCCvFgvFgx8EjsTH+dW2pK6MOEgoIbM=";
  meta = {
    description = "Independently maintained ACP adapter for pi coding agent";
    homepage = "https://github.com/regadas/pi-acp";
    license = lib.licenses.mit;
    mainProgram = "pi-acp";
  };
}
