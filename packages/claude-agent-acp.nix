{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "claude-agent-acp";
  version = "0.31.0";
  src = pkgs.fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "claude-agent-acp";
    rev = "v${version}";
    hash = "sha256-lWAuf8EO5Y1x1HhcNrbNQUgOsdGG5SXYTiXevWBEhSQ=";
  };
  npmDepsHash = "sha256-lKGj7J9UduqfVPUiYh+ZcCqZ8tfzmV4mVI2dGSZWj0Q=";
  meta = {
    description = "Claude Agent ACP bridge";
    homepage = "https://github.com/agentclientprotocol/claude-agent-acp";
    license = lib.licenses.asl20;
  };
}
