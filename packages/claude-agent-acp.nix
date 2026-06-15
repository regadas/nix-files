{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "claude-agent-acp";
  version = "0.45.0";
  src = pkgs.fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "claude-agent-acp";
    rev = "v${version}";
    hash = "sha256-Z1omAJdBc1ZvxDY0bz7uZner5DLOEMFuUEi6g+pQ5jU=";
  };
  npmDepsHash = "sha256-fjap/4Dmh3uFegmySci7X+fFRF+6bo/RQuJqQUckPfA=";
  meta = {
    description = "Claude Agent ACP bridge";
    homepage = "https://github.com/agentclientprotocol/claude-agent-acp";
    license = lib.licenses.asl20;
  };
}
