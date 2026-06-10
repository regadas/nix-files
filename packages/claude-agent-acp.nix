{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "claude-agent-acp";
  version = "0.44.0";
  src = pkgs.fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "claude-agent-acp";
    rev = "v${version}";
    hash = "sha256-/cqv7GuBVW3ph0vy+/Ecxnmq4vLtA3qCDE/0tHRjLHo=";
  };
  npmDepsHash = "sha256-N/eNDxkJm5QMvH6aRsdoUZ4V775S8zudDH6+E2LgRRc=";
  meta = {
    description = "Claude Agent ACP bridge";
    homepage = "https://github.com/agentclientprotocol/claude-agent-acp";
    license = lib.licenses.asl20;
  };
}
