{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "codex-acp";
  version = "0.14.0";
  src = pkgs.fetchFromGitHub {
    owner = "zed-industries";
    repo = "codex-acp";
    rev = "v${version}";
    hash = "sha256-MjKaJV0VfMXYcH3oaCxscTTMop6tmA5Wl/vpPVDGg0E=";
  };
  sourceRoot = "${src.name}/npm";
  postPatch = ''
    cat > package-lock.json << 'LOCKFILE'
    {"name":"@zed-industries/codex-acp","version":"0.14.0","lockfileVersion":3,"requires":true,"packages":{"":{"name":"@zed-industries/codex-acp","version":"0.14.0","license":"Apache-2.0","optionalDependencies":{"@zed-industries/codex-acp-darwin-arm64":"0.14.0","@zed-industries/codex-acp-darwin-x64":"0.14.0","@zed-industries/codex-acp-linux-arm64":"0.14.0","@zed-industries/codex-acp-linux-x64":"0.14.0","@zed-industries/codex-acp-win32-arm64":"0.14.0","@zed-industries/codex-acp-win32-x64":"0.14.0"}},"node_modules/@zed-industries/codex-acp-darwin-arm64":{"version":"0.14.0","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-darwin-arm64/-/codex-acp-darwin-arm64-0.14.0.tgz","integrity":"sha512-FWjHKlNJTZmXWM/2/GAQAg0WJEjPlfxEQJgvfxuzK1xZh81CDg9U6uSgZ1ggBkkN2bOoCnOupvGAPOmBoL5m2Q==","cpu":["arm64"],"license":"Apache-2.0","optional":true,"os":["darwin"]},"node_modules/@zed-industries/codex-acp-darwin-x64":{"version":"0.14.0","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-darwin-x64/-/codex-acp-darwin-x64-0.14.0.tgz","integrity":"sha512-KgC92J5wxOJM2N0VMNX7UQSGHVKa7xQCFsniWcxClsLWleJGlUdGlde5Aefd/yoU0J86ii6HCK8RfalUC76Inw==","cpu":["x64"],"license":"Apache-2.0","optional":true,"os":["darwin"]},"node_modules/@zed-industries/codex-acp-linux-arm64":{"version":"0.14.0","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-linux-arm64/-/codex-acp-linux-arm64-0.14.0.tgz","integrity":"sha512-KGfQq0/tdY31XBsdLe5nsKiV97pcsCruW28UDw7sgHUjPq8NPh9IiDdVj+xr1L4opihnswGelcoVvya+Vng8jQ==","cpu":["arm64"],"license":"Apache-2.0","optional":true,"os":["linux"]},"node_modules/@zed-industries/codex-acp-linux-x64":{"version":"0.14.0","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-linux-x64/-/codex-acp-linux-x64-0.14.0.tgz","integrity":"sha512-y1wrDOTJ/OYjYNRVmrf9Jti2571DjSp1xe5lSiZ9pBohA4oUQk9YIhlnv7NzeI0PYWyrjLd6QpQ09wTfxZFC8w==","cpu":["x64"],"license":"Apache-2.0","optional":true,"os":["linux"]},"node_modules/@zed-industries/codex-acp-win32-arm64":{"version":"0.14.0","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-win32-arm64/-/codex-acp-win32-arm64-0.14.0.tgz","integrity":"sha512-mUNZYfcpkM9YSs0tFzH7j2NHlxpjScFz2lpyJKiMl8wcTHLU8HYzeJZ7xodHzsIJrb5YMKxZ44zkBM3FBGAVaw==","cpu":["arm64"],"license":"Apache-2.0","optional":true,"os":["win32"]},"node_modules/@zed-industries/codex-acp-win32-x64":{"version":"0.14.0","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-win32-x64/-/codex-acp-win32-x64-0.14.0.tgz","integrity":"sha512-KYckY87//om8Vsnb3fMUOkex76z2MF+e3H/n91tXnBep9ecnDT0rtEuoTvr4gP7evAf210YoSSGi0BB4ljse4w==","cpu":["x64"],"license":"Apache-2.0","optional":true,"os":["win32"]}}}
    LOCKFILE
  '';
  npmDepsHash = "sha256-vm3RWzQAICJcy1IEeLF+6w/DkXFEv/LCBZnHiCu3DHk=";
  dontNpmBuild = true;
  meta = {
    description = "An ACP-compatible coding agent powered by Codex";
    homepage = "https://github.com/zed-industries/codex-acp";
    license = lib.licenses.asl20;
  };
}
