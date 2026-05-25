{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "claude-agent-acp";
  version = "0.37.0";
  src = pkgs.fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "claude-agent-acp";
    rev = "v${version}";
    hash = "sha256-x3dJiEntNNeh4kmChi+FddUOlvtDD8nWwkHNtcH93HU=";
  };
  npmDepsHash = "sha256-8V1yf32GRYmS0f4M9HXclkY7byFWozT+RjlXHkFFdoA=";
  meta = {
    description = "Claude Agent ACP bridge";
    homepage = "https://github.com/agentclientprotocol/claude-agent-acp";
    license = lib.licenses.asl20;
  };
}
