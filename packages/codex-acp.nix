{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "codex-acp";
  version = "0.12.0";
  src = pkgs.fetchFromGitHub {
    owner = "zed-industries";
    repo = "codex-acp";
    rev = "v${version}";
    hash = "sha256-qPqg95FpXHBtyHBJtrfJUwu9GokfmOJgKgqLKQ48u+8=";
  };
  sourceRoot = "${src.name}/npm";
  postPatch = ''
    cat > package-lock.json << 'LOCKFILE'
    {"name":"@zed-industries/codex-acp","version":"0.12.0","lockfileVersion":3,"requires":true,"packages":{"":{"name":"@zed-industries/codex-acp","version":"0.12.0","license":"Apache-2.0","optionalDependencies":{"@zed-industries/codex-acp-darwin-arm64":"0.12.0","@zed-industries/codex-acp-darwin-x64":"0.12.0","@zed-industries/codex-acp-linux-arm64":"0.12.0","@zed-industries/codex-acp-linux-x64":"0.12.0","@zed-industries/codex-acp-win32-arm64":"0.12.0","@zed-industries/codex-acp-win32-x64":"0.12.0"}},"node_modules/@zed-industries/codex-acp-darwin-arm64":{"version":"0.12.0","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-darwin-arm64/-/codex-acp-darwin-arm64-0.12.0.tgz","integrity":"sha512-RvTXH21sLpswEo8xLeQXcA/uWZauyNP1y+WI6b355+/o7sQ5wrvBkxt+NyhaJXJIQvbfdpl04LND4cmM+DTcNg==","cpu":["arm64"],"license":"Apache-2.0","optional":true,"os":["darwin"]},"node_modules/@zed-industries/codex-acp-darwin-x64":{"version":"0.12.0","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-darwin-x64/-/codex-acp-darwin-x64-0.12.0.tgz","integrity":"sha512-N7EhrUTioix3L21qnm6kZzAESc+B7Mac+/uW3khn/UQe7fJJ7u1ojbgMPDdGo/8Xm6HBBXgak2NOj7mJ+NNXSw==","cpu":["x64"],"license":"Apache-2.0","optional":true,"os":["darwin"]},"node_modules/@zed-industries/codex-acp-linux-arm64":{"version":"0.12.0","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-linux-arm64/-/codex-acp-linux-arm64-0.12.0.tgz","integrity":"sha512-Kq35FclgZiSMBKyf80PnCvvJ3xfMjZIkPJXpci35U/VqXVQelhHCwYWwA3waTxvW07tNHxsehv1eQICz7wZdVQ==","cpu":["arm64"],"license":"Apache-2.0","optional":true,"os":["linux"]},"node_modules/@zed-industries/codex-acp-linux-x64":{"version":"0.12.0","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-linux-x64/-/codex-acp-linux-x64-0.12.0.tgz","integrity":"sha512-twmX9noSqfgWgVkGG1dd9u20Pxp8vNRXggvJ61RQSrNYITGuqHil2F3ViYICZoXyr9w1gok28bWG5DU2d9adPg==","cpu":["x64"],"license":"Apache-2.0","optional":true,"os":["linux"]},"node_modules/@zed-industries/codex-acp-win32-arm64":{"version":"0.12.0","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-win32-arm64/-/codex-acp-win32-arm64-0.12.0.tgz","integrity":"sha512-VoFsTIrQopO917x2EpxYXm3jTIoSknCbzP76FwX9uOThlRms+M+fHWJ4kJttOPpeofz1ulAS3vPVMQ3WNlvnhw==","cpu":["arm64"],"license":"Apache-2.0","optional":true,"os":["win32"]},"node_modules/@zed-industries/codex-acp-win32-x64":{"version":"0.12.0","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-win32-x64/-/codex-acp-win32-x64-0.12.0.tgz","integrity":"sha512-HImgXGIYgW6Wxr3rylrHS7Dzs35zvcQQB7eqAEWZ2Lj+3AxP/7TViW9KkjS+PTPnVWqpTkz0hYDQhk63Ruw3JA==","cpu":["x64"],"license":"Apache-2.0","optional":true,"os":["win32"]}}}
    LOCKFILE
  '';
  npmDepsHash = "sha256-fJSQaU5H6eaixtHSrkQa76KY3pNqbAuToPUbRLi/obo=";
  dontNpmBuild = true;
  meta = {
    description = "An ACP-compatible coding agent powered by Codex";
    homepage = "https://github.com/zed-industries/codex-acp";
    license = lib.licenses.asl20;
  };
}
