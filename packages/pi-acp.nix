{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "pi-acp";
  # Independently maintained continuation of svkozak/pi-acp. Provides stable
  # ACP v1 lifecycle/history replay, strict subprocess ownership and timeout
  # quarantine, atomic session mapping, negotiated auth/terminal behavior, and
  # model-aware thinking levels. Requires pi >= 0.80.4.
  version = "0.1.0-unstable-2026-07-17-96a27039";
  src = pkgs.fetchFromGitHub {
    owner = "regadas";
    repo = "pi-acp";
    rev = "96a27039d483964e110c9d54352dfadb122f957e";
    hash = "sha256-XwYPWfVVUE9/qlJ/FKdcNwAGs2UVMerDMHJYlud4/Dc=";
  };
  npmDepsHash = "sha256-o/PZJPyWSlIwTCCvFgvFgx8EjsTH+dW2pK6MOEgoIbM=";
  meta = {
    description = "Independently maintained ACP adapter for pi coding agent";
    homepage = "https://github.com/regadas/pi-acp";
    license = lib.licenses.mit;
    mainProgram = "pi-acp";
  };
}
