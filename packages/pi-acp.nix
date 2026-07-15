{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "pi-acp";
  # Temporary pinned fork of svkozak/pi-acp 0.0.31 (branch
  # fix/agent-settled-acp-turn): adds the agent_settled, in-turn startup,
  # compaction, stable ACP v1 lifecycle, file-only tool-location fixes, and
  # visible custom-message live delivery/replay; requires pi >= 0.80.4 and
  # mitigates Zed worktree scanner runaway. Drop back to the upstream release
  # once equivalent fixes are merged (see
  # svkozak/pi-acp issues #59/#70 and PRs #61/#69).
  version = "0.0.31-unstable-2026-07-15";
  src = pkgs.fetchFromGitHub {
    owner = "regadas";
    repo = "pi-acp";
    rev = "fe794c523e25981db24060841e512f75e8dd1260";
    hash = "sha256-FViHOWTe01Ia1pZm+yYkD5vCNeiG/uU/aaPjVBpm3Fg=";
  };
  npmDepsHash = "sha256-UDqVwbrUGLy25T7akmsUnfXfPJ+lLTuRjRSQMYdyjDM=";
  meta = {
    description = "ACP adapter for pi coding agent (pinned fork with stable ACP v1 and agent lifecycle fixes)";
    homepage = "https://github.com/regadas/pi-acp";
    license = lib.licenses.mit;
    mainProgram = "pi-acp";
  };
}
