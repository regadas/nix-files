{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "claude-agent-acp";
  version = "0.57.0";
  src = pkgs.fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "claude-agent-acp";
    rev = "v${version}";
    hash = "sha256-AeIXSj+PWX5NwaC3K1VgY2PxhfhAWp60djeO191gSXg=";
  };
  npmDepsHash = "sha256-owpYw1g1USNIx8RHb3CXevlDhtboKv89oiwIDCwhsFg=";
  meta = {
    description = "Claude Agent ACP bridge";
    homepage = "https://github.com/agentclientprotocol/claude-agent-acp";
    license = lib.licenses.asl20;
  };
}
