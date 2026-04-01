{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "codex-acp";
  version = "0.11.1";
  src = pkgs.fetchFromGitHub {
    owner = "zed-industries";
    repo = "codex-acp";
    rev = "v${version}";
    hash = "sha256-ufKRtfkr+CFaVg84vsE3OAvrYhVW6kQclIW2lfeaj+Y=";
  };
  sourceRoot = "${src.name}/npm";
  postPatch = ''
    cat > package-lock.json << 'LOCKFILE'
    {"name":"@zed-industries/codex-acp","version":"0.11.1","lockfileVersion":3,"requires":true,"packages":{"":{"name":"@zed-industries/codex-acp","version":"0.11.1","license":"Apache-2.0","optionalDependencies":{"@zed-industries/codex-acp-darwin-arm64":"0.11.1","@zed-industries/codex-acp-darwin-x64":"0.11.1","@zed-industries/codex-acp-linux-arm64":"0.11.1","@zed-industries/codex-acp-linux-x64":"0.11.1","@zed-industries/codex-acp-win32-arm64":"0.11.1","@zed-industries/codex-acp-win32-x64":"0.11.1"}},"node_modules/@zed-industries/codex-acp-darwin-arm64":{"version":"0.11.1","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-darwin-arm64/-/codex-acp-darwin-arm64-0.11.1.tgz","integrity":"sha512-zJ/CsOSH1NniKGF/liBtWokdkFtymTWeELV4lDlgMgzVSqMHQTB+t6fFSrxhwOcXHK86TErxAT81Z61e+bq5gg==","cpu":["arm64"],"license":"Apache-2.0","optional":true,"os":["darwin"]},"node_modules/@zed-industries/codex-acp-darwin-x64":{"version":"0.11.1","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-darwin-x64/-/codex-acp-darwin-x64-0.11.1.tgz","integrity":"sha512-UZjIsEZPLeYMk+fj2ot1oT+tWuJpw+iZS9awnbmJYxTEEXMpY8BE6xQXMy7iyyxJ346We5MEpAdxg730vcem5Q==","cpu":["x64"],"license":"Apache-2.0","optional":true,"os":["darwin"]},"node_modules/@zed-industries/codex-acp-linux-arm64":{"version":"0.11.1","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-linux-arm64/-/codex-acp-linux-arm64-0.11.1.tgz","integrity":"sha512-I1f6WoSLbLlsWq4zH+vtwdoc4Y41mqRXPpSkfgIifxBw34QmWJmi37etZ7lKTYp6R+J/Z4PUN0rsmnsmKpBZTw==","cpu":["arm64"],"license":"Apache-2.0","optional":true,"os":["linux"]},"node_modules/@zed-industries/codex-acp-linux-x64":{"version":"0.11.1","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-linux-x64/-/codex-acp-linux-x64-0.11.1.tgz","integrity":"sha512-30vSoZuW1DP6Nuz24Gg3jgVC37IYe0bZ/Fgc5+372gc0h72NN4zHYAbu5bRd/gUJ9GdwABKrrEPCoFPlOTVTnQ==","cpu":["x64"],"license":"Apache-2.0","optional":true,"os":["linux"]},"node_modules/@zed-industries/codex-acp-win32-arm64":{"version":"0.11.1","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-win32-arm64/-/codex-acp-win32-arm64-0.11.1.tgz","integrity":"sha512-yisGPG7JMJBtOTOB6qwzroOLfiQebDrBnybzvjOfWiSIHeha25Jf1nTlWrlZcEiV/eeX3/lERuU1MxftjK3Vgg==","cpu":["arm64"],"license":"Apache-2.0","optional":true,"os":["win32"]},"node_modules/@zed-industries/codex-acp-win32-x64":{"version":"0.11.1","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-win32-x64/-/codex-acp-win32-x64-0.11.1.tgz","integrity":"sha512-nOdlp/xHQGzqt+GnB2rrpk0sT7pPJVKkL9M+UhmoFPSFwjWrkzAOJukbT4P59wU1mVBTe84dEW6UnzydWIrGJw==","cpu":["x64"],"license":"Apache-2.0","optional":true,"os":["win32"]}}}
    LOCKFILE
  '';
  npmDepsHash = "sha256-/eVnJlkOSFEu/UVdia+3aJXupJ+oJmgcas73THeZFHY=";
  dontNpmBuild = true;
  meta = {
    description = "An ACP-compatible coding agent powered by Codex";
    homepage = "https://github.com/zed-industries/codex-acp";
    license = lib.licenses.asl20;
  };
}
