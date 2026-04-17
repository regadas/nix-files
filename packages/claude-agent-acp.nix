{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "claude-agent-acp";
  version = "0.28.0";
  src = pkgs.fetchFromGitHub {
    owner = "zed-industries";
    repo = "claude-agent-acp";
    rev = "v${version}";
    hash = "sha256-b7hKmdTE2i1Lnz8WDP47ZTwbZbXLAoctXfTGcEzG09w=";
  };
  npmDepsHash = "sha256-PmYWrXNC05536DnTCHyYFTCjMwTdDF+RXPqgG+7vT2U=";
  meta = {
    description = "Zed's Claude Agent ACP bridge";
    homepage = "https://github.com/zed-industries/claude-agent-acp";
    license = lib.licenses.asl20;
  };
}
