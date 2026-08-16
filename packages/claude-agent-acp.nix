{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "claude-agent-acp";
  version = "0.69.0";
  src = pkgs.fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "claude-agent-acp";
    rev = "v${version}";
    hash = "sha256-x0k+5EhGx3y6Xd2rswTWMfYb0ZAYf5D+DaACr14uNMM=";
  };
  npmDepsHash = "sha256-Zr9aKUoIVheaFBMBmpZovsP0hWt0tqnxk/PMEjgP9HY=";
  meta = {
    description = "Claude Agent ACP bridge";
    homepage = "https://github.com/agentclientprotocol/claude-agent-acp";
    license = lib.licenses.asl20;
  };
}
