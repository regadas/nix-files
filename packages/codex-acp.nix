{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "codex-acp";
  version = "1.4.0";
  src = pkgs.fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "codex-acp";
    rev = "v${version}";
    hash = "sha256-9oUtDBE1HINQaJhk4Le5GWN3YODNwDpRaVZlnDV9a5c=";
  };
  npmDepsHash = "sha256-tHnOMBXerUKBqTQM+jbXT3F9wgodvP6xdWJd7XNwhxE=";
  meta = {
    description = "An ACP-compatible coding agent powered by Codex";
    homepage = "https://github.com/agentclientprotocol/codex-acp";
    license = lib.licenses.asl20;
    mainProgram = "codex-acp";
  };
}
