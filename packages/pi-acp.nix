{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "pi-acp";
  # Independently maintained continuation of svkozak/pi-acp. Provides stable
  # ACP v1 lifecycle/history replay, strict subprocess ownership and timeout
  # quarantine, autonomous-run prompt serialization, atomic session mapping,
  # negotiated auth/terminal behavior, and model-aware thinking levels.
  # Requires pi >= 0.80.4.
  version = "0.1.0-unstable-2026-09-15-3f46f29";
  src = pkgs.fetchFromGitHub {
    owner = "regadas";
    repo = "pi-acp";
    rev = "3f46f29c7844b0d40df2fd1df6f0ace9d24378da";
    hash = "sha256-WNcIwIGLJoGIU0KtBpr3eW5WjbFXJQOYMJTs242w1qk=";
  };
  npmDepsHash = "sha256-9Z+rHeVkkP3ypBQcd07Txi3lvwoqEGxgiuw4Cc7FRWs=";
  # Validate in checkPhase, not again in npm pack's prepack hook.
  npmPackFlags = [ "--ignore-scripts" ];
  doCheck = true;
  checkPhase = ''
    runHook preCheck
    npm run format:check
    npm run typecheck
    npm run lint
    # Avoid competing test processes exhausting the FIFO test's timeout.
    npm test -- --test-concurrency=1
    runHook postCheck
  '';
  meta = {
    description = "Independently maintained ACP adapter for pi coding agent";
    homepage = "https://github.com/regadas/pi-acp";
    license = lib.licenses.mit;
    mainProgram = "pi-acp";
  };
}
