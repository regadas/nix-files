{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "codex-acp";
  version = "1.1.4";
  src = pkgs.fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "codex-acp";
    rev = "v${version}";
    hash = "sha256-oBg/i4ewa6dF7d/lK0JaNOCBrgXTdsltLB+xvwXAV7E=";
  };
  npmDepsHash = "sha256-r1c2Z2TbcU0X6mUdF5jpu3ldLnK+Yd+r0qQzjRHJ0mw=";
  meta = {
    description = "An ACP-compatible coding agent powered by Codex";
    homepage = "https://github.com/agentclientprotocol/codex-acp";
    license = lib.licenses.asl20;
    mainProgram = "codex-acp";
  };
}
