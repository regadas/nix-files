{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "codex-acp";
  version = "1.1.7";
  src = pkgs.fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "codex-acp";
    rev = "v${version}";
    hash = "sha256-RY1iiajNR3eJI9WYARZnbIHnDl5+gmlPo3GVjJEJ9Zs=";
  };
  npmDepsHash = "sha256-c/sbGziA3Y2mOcPRD3K0PSd8sAVXSQuip8fE/eojl+Y=";
  meta = {
    description = "An ACP-compatible coding agent powered by Codex";
    homepage = "https://github.com/agentclientprotocol/codex-acp";
    license = lib.licenses.asl20;
    mainProgram = "codex-acp";
  };
}
