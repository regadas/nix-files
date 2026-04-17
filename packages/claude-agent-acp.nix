{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "claude-agent-acp";
  version = "0.29.0";
  src = pkgs.fetchFromGitHub {
    owner = "zed-industries";
    repo = "claude-agent-acp";
    rev = "v${version}";
    hash = "sha256-L2Kq4Lk5gHqE9rpBnrKcWXMaSQqEZHtcayjGnK4fYEQ=";
  };
  npmDepsHash = "sha256-CEB4zgWC+jVpqmwbSCwE9xWoi+XiVkpNiXpDzsvbhII=";
  meta = {
    description = "Zed's Claude Agent ACP bridge";
    homepage = "https://github.com/zed-industries/claude-agent-acp";
    license = lib.licenses.asl20;
  };
}
