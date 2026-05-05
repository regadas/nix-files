{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "claude-agent-acp";
  version = "0.32.0";
  src = pkgs.fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "claude-agent-acp";
    rev = "v${version}";
    hash = "sha256-egYGwkN8iexw42EIhUgKb+QuAKfH4lKts0lftzfHAiY=";
  };
  npmDepsHash = "sha256-sUB/S3EycM3FGibAaZMA1T7tCyDu2XfkSg86qcABmYk=";
  meta = {
    description = "Claude Agent ACP bridge";
    homepage = "https://github.com/agentclientprotocol/claude-agent-acp";
    license = lib.licenses.asl20;
  };
}
