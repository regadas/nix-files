{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "claude-agent-acp";
  version = "0.26.0";
  src = pkgs.fetchFromGitHub {
    owner = "zed-industries";
    repo = "claude-agent-acp";
    rev = "v${version}";
    hash = "sha256-2G8gjMCnk3W1I2+4sNsumL15ts9bLXAOMguCmwnzWSA=";
  };
  npmDepsHash = "sha256-msm4L8Yi7ma2eHOYXbZx+Qtrx4TzK7FV3HpVzRhQ19o=";
  meta = {
    description = "Zed's Claude Agent ACP bridge";
    homepage = "https://github.com/zed-industries/claude-agent-acp";
    license = lib.licenses.asl20;
  };
}
