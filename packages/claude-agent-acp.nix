{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "claude-agent-acp";
  version = "0.62.0";
  src = pkgs.fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "claude-agent-acp";
    rev = "v${version}";
    hash = "sha256-MF/gzEr3z64tRd+2TX36/VAHSPYJzYU5+1qR9OEu97Q=";
  };
  npmDepsHash = "sha256-Cq5eurS4BgP4h+ASXe+bJiyLzJ27H0S21Dsusw/c+gc=";
  meta = {
    description = "Claude Agent ACP bridge";
    homepage = "https://github.com/agentclientprotocol/claude-agent-acp";
    license = lib.licenses.asl20;
  };
}
