{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "codex-acp";
  version = "0.13.0";
  src = pkgs.fetchFromGitHub {
    owner = "zed-industries";
    repo = "codex-acp";
    rev = "v${version}";
    hash = "sha256-8Mz3xPhGSjaucZ9c0etGOe4JJC8vJhGFOnAhkwXmhyY=";
  };
  sourceRoot = "${src.name}/npm";
  postPatch = ''
    cat > package-lock.json << 'LOCKFILE'
    {"name":"@zed-industries/codex-acp","version":"0.13.0","lockfileVersion":3,"requires":true,"packages":{"":{"name":"@zed-industries/codex-acp","version":"0.13.0","license":"Apache-2.0","optionalDependencies":{"@zed-industries/codex-acp-darwin-arm64":"0.13.0","@zed-industries/codex-acp-darwin-x64":"0.13.0","@zed-industries/codex-acp-linux-arm64":"0.13.0","@zed-industries/codex-acp-linux-x64":"0.13.0","@zed-industries/codex-acp-win32-arm64":"0.13.0","@zed-industries/codex-acp-win32-x64":"0.13.0"}},"node_modules/@zed-industries/codex-acp-darwin-arm64":{"version":"0.13.0","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-darwin-arm64/-/codex-acp-darwin-arm64-0.13.0.tgz","integrity":"sha512-SNJbpxOD1b98pK1Qw2pZjFJbfYBICheRs3mYvLMgHABehdypaeYKnEmEGp3Bu/gUT6JFAtOPRtaU+sfxKzgCvw==","cpu":["arm64"],"license":"Apache-2.0","optional":true,"os":["darwin"]},"node_modules/@zed-industries/codex-acp-darwin-x64":{"version":"0.13.0","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-darwin-x64/-/codex-acp-darwin-x64-0.13.0.tgz","integrity":"sha512-R5CQi2mmi9Nk2P6t48T5JoOQx0jWnP9DzLf5jcTnCLqk1tsg9XtASpLBtsedll9MesBax6aflDvz+0dyWW+3Mw==","cpu":["x64"],"license":"Apache-2.0","optional":true,"os":["darwin"]},"node_modules/@zed-industries/codex-acp-linux-arm64":{"version":"0.13.0","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-linux-arm64/-/codex-acp-linux-arm64-0.13.0.tgz","integrity":"sha512-Z3f2D94SOgy+BVFEIWxoR64IQB+d4/zgjHB1oeBS5yAYKaX7Wv3W6x+XGktDx+KnfD7c9vSSdFdknI6cZ8hO7g==","cpu":["arm64"],"license":"Apache-2.0","optional":true,"os":["linux"]},"node_modules/@zed-industries/codex-acp-linux-x64":{"version":"0.13.0","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-linux-x64/-/codex-acp-linux-x64-0.13.0.tgz","integrity":"sha512-sWNfyeuwEHPo6DSbcjklnBr7M8+MWd2b9oVbIqgwxryTPpm0ZPF3U28PWR3/vGxS5UmhGiZIShe9tqx8FsvvBg==","cpu":["x64"],"license":"Apache-2.0","optional":true,"os":["linux"]},"node_modules/@zed-industries/codex-acp-win32-arm64":{"version":"0.13.0","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-win32-arm64/-/codex-acp-win32-arm64-0.13.0.tgz","integrity":"sha512-oxd6IF5dVHsa7zLnK1VAClzGADqn4N9TVSPb+3X4CqnOs4y4M9JPHSEEPiRYF44ibDJTWR+9EZ673djRYEGraw==","cpu":["arm64"],"license":"Apache-2.0","optional":true,"os":["win32"]},"node_modules/@zed-industries/codex-acp-win32-x64":{"version":"0.13.0","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-win32-x64/-/codex-acp-win32-x64-0.13.0.tgz","integrity":"sha512-675+tZlhzDMBJUrgiTnbcCMB15MQ8B0Ih/GmzB9MqW/FDFJqOFjXe4P+M7joePzQqa7QYwf36le50sDokXDrew==","cpu":["x64"],"license":"Apache-2.0","optional":true,"os":["win32"]}}}
    LOCKFILE
  '';
  npmDepsHash = "sha256-+sXxuG+14AAH57Yo5o+4c3gqluLaIIjksDQzKGVc5v4=";
  dontNpmBuild = true;
  meta = {
    description = "An ACP-compatible coding agent powered by Codex";
    homepage = "https://github.com/zed-industries/codex-acp";
    license = lib.licenses.asl20;
  };
}
