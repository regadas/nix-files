{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "claude-agent-acp";
  version = "0.47.0";
  src = pkgs.fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "claude-agent-acp";
    rev = "v${version}";
    hash = "sha256-ibSgakYoTde8sIj063W/UP2s0VZ3FDZTsZnExysW5uc=";
  };
  npmDepsHash = "sha256-I05Irae6TDA3+KXMzkbV9Ky271ACbru7ztlQUDRwfmU=";
  meta = {
    description = "Claude Agent ACP bridge";
    homepage = "https://github.com/agentclientprotocol/claude-agent-acp";
    license = lib.licenses.asl20;
  };
}
