{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "claude-agent-acp";
  version = "0.25.1";
  src = pkgs.fetchFromGitHub {
    owner = "zed-industries";
    repo = "claude-agent-acp";
    rev = "v${version}";
    hash = "sha256-OJit4mQxVqdMbohGCbmZfycCzZnjtDX5NblwJ7QBzL4=";
  };
  npmDepsHash = "sha256-KDYRPlPgi9K9HjOIopkUcGnauq034otdIHm0gQ2PjsU=";
  meta = {
    description = "Zed's Claude Agent ACP bridge";
    homepage = "https://github.com/zed-industries/claude-agent-acp";
    license = lib.licenses.asl20;
  };
}
