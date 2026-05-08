{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "claude-agent-acp";
  version = "0.33.1";
  src = pkgs.fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "claude-agent-acp";
    rev = "v${version}";
    hash = "sha256-FwcIJf/tfH6prDFKtOo7X1mTocibf4Ne6JHOS9ITG8U=";
  };
  npmDepsHash = "sha256-y795LyNjSJjTpIqtA5bC/AgeFLghM0yU5xQRD3m+Ajs=";
  meta = {
    description = "Claude Agent ACP bridge";
    homepage = "https://github.com/agentclientprotocol/claude-agent-acp";
    license = lib.licenses.asl20;
  };
}
