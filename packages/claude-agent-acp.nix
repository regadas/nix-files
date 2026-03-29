{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "claude-agent-acp";
  version = "0.24.2";
  src = pkgs.fetchFromGitHub {
    owner = "zed-industries";
    repo = "claude-agent-acp";
    rev = "v${version}";
    hash = "sha256-SRVbLcGrH5pJt6yfM0ObSso68M+yGateIVYf/kFVDhE=";
  };
  npmDepsHash = "sha256-V5lBQNhpL+/Mok9bEVSOrrHSv9B9pXKJswcXW+QDnAs=";
  meta = {
    description = "Zed's Claude Agent ACP bridge";
    homepage = "https://github.com/zed-industries/claude-agent-acp";
    license = lib.licenses.asl20;
  };
}
