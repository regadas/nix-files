{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "claude-agent-acp";
  version = "0.30.0";
  src = pkgs.fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "claude-agent-acp";
    rev = "v${version}";
    hash = "sha256-Fb5P9LUPIeVYZ7LDVreHZCtuXUtHNdZjqC4gRVGVg50=";
  };
  npmDepsHash = "sha256-lF1me4oRLCol2Nx14BWjognjmzK6GzHZJajS6s4tJSQ=";
  meta = {
    description = "Claude Agent ACP bridge";
    homepage = "https://github.com/agentclientprotocol/claude-agent-acp";
    license = lib.licenses.asl20;
  };
}
