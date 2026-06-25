{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "claude-agent-acp";
  version = "0.51.0";
  src = pkgs.fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "claude-agent-acp";
    rev = "v${version}";
    hash = "sha256-ZmpzApfWblMZkL/Sgm4jQV8iG9vOznXXTOzZcVQ/JEw=";
  };
  npmDepsHash = "sha256-2OoD2IQz6jSqrQWx17ZCZqZAUQKgMmJzLi/V+CgloeI=";
  meta = {
    description = "Claude Agent ACP bridge";
    homepage = "https://github.com/agentclientprotocol/claude-agent-acp";
    license = lib.licenses.asl20;
  };
}
