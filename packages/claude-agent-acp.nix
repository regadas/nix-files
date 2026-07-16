{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "claude-agent-acp";
  version = "0.59.0";
  src = pkgs.fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "claude-agent-acp";
    rev = "v${version}";
    hash = "sha256-G/qV8VJevI7Ed7Rm+S8GUtAmnkG5aEg8cLoudQmDpGo=";
  };
  npmDepsHash = "sha256-Zeh9l58GOWVSwNAlCnUkKgND2IMEor4WXDiw+w+NGq8=";
  meta = {
    description = "Claude Agent ACP bridge";
    homepage = "https://github.com/agentclientprotocol/claude-agent-acp";
    license = lib.licenses.asl20;
  };
}
