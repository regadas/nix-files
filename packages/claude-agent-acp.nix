{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "claude-agent-acp";
  version = "0.55.0";
  src = pkgs.fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "claude-agent-acp";
    rev = "v${version}";
    hash = "sha256-HVhXJJshq41qMqyaxWkNi//TeZUp+PZwKnppJ1lYaIw=";
  };
  npmDepsHash = "sha256-rfBlKdsr3YaBi8eQ40hov2B71pg7zL57WV4oX4z+SAU=";
  meta = {
    description = "Claude Agent ACP bridge";
    homepage = "https://github.com/agentclientprotocol/claude-agent-acp";
    license = lib.licenses.asl20;
  };
}
