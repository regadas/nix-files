{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "claude-agent-acp";
  version = "0.56.0";
  src = pkgs.fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "claude-agent-acp";
    rev = "v${version}";
    hash = "sha256-W/ui08oFlG2g91Vz4tkL+tSNoMFqswkP9jAXF0N1/Y4=";
  };
  npmDepsHash = "sha256-6UWfi1J7EqkIyqFmUArbdBTcKi7Nn39e/ZHW4A+nAwc=";
  meta = {
    description = "Claude Agent ACP bridge";
    homepage = "https://github.com/agentclientprotocol/claude-agent-acp";
    license = lib.licenses.asl20;
  };
}
