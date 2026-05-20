{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "claude-agent-acp";
  version = "0.36.1";
  src = pkgs.fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "claude-agent-acp";
    rev = "v${version}";
    hash = "sha256-mtdmzKuZF1eEt8FKm+VYp9h9igfRzQPQ2HCbq+IRVDw=";
  };
  npmDepsHash = "sha256-3lX2fAjVYWeFl9FAsSou30WOJ8st9lUdyt54hC4jN1E=";
  meta = {
    description = "Claude Agent ACP bridge";
    homepage = "https://github.com/agentclientprotocol/claude-agent-acp";
    license = lib.licenses.asl20;
  };
}
