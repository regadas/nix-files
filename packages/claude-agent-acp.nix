{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "claude-agent-acp";
  version = "0.42.0";
  src = pkgs.fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "claude-agent-acp";
    rev = "v${version}";
    hash = "sha256-yvljKMNVCQAFcobHzgPwXSTYGU1IWdOGdX6nsxBfWyw=";
  };
  npmDepsHash = "sha256-ecMy4cgsM+PKdsiqAG4Deoiz8DQeJRDgZ8aWzjS/EjA=";
  meta = {
    description = "Claude Agent ACP bridge";
    homepage = "https://github.com/agentclientprotocol/claude-agent-acp";
    license = lib.licenses.asl20;
  };
}
