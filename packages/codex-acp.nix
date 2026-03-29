{ pkgs, lib, ... }:

pkgs.buildNpmPackage rec {
  pname = "codex-acp";
  version = "0.10.0";
  src = pkgs.fetchFromGitHub {
    owner = "zed-industries";
    repo = "codex-acp";
    rev = "v${version}";
    hash = "sha256-pFlQ1ETjSfZ9oDhJ3J6AWgTyfLSPWf6oFJ/UiOTqVU8=";
  };
  sourceRoot = "${src.name}/npm";
  postPatch = ''
    cat > package-lock.json << 'LOCKFILE'
    {"name":"@zed-industries/codex-acp","version":"0.10.0","lockfileVersion":3,"requires":true,"packages":{"":{"name":"@zed-industries/codex-acp","version":"0.10.0","license":"Apache-2.0","optionalDependencies":{"@zed-industries/codex-acp-darwin-arm64":"0.10.0","@zed-industries/codex-acp-darwin-x64":"0.10.0","@zed-industries/codex-acp-linux-arm64":"0.10.0","@zed-industries/codex-acp-linux-x64":"0.10.0","@zed-industries/codex-acp-win32-arm64":"0.10.0","@zed-industries/codex-acp-win32-x64":"0.10.0"}},"node_modules/@zed-industries/codex-acp-darwin-arm64":{"version":"0.10.0","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-darwin-arm64/-/codex-acp-darwin-arm64-0.10.0.tgz","integrity":"sha512-zlIZH+X2aEfxC5UgnIoYbX0cG3/MpRUsQAGJbrcBbgKp0mhuBFtMJHZ426JC5rb3pv8amo1MmDeARZUQ99U/CQ==","cpu":["arm64"],"license":"Apache-2.0","optional":true,"os":["darwin"]},"node_modules/@zed-industries/codex-acp-darwin-x64":{"version":"0.10.0","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-darwin-x64/-/codex-acp-darwin-x64-0.10.0.tgz","integrity":"sha512-TFMF9YqfWplnYpWRaUauRbtps1ow1S47MVcBv21/Sd55gRMWWYWSogRLDyAcoMC4y9pdI2bYhx33u7jYhJnj5w==","cpu":["x64"],"license":"Apache-2.0","optional":true,"os":["darwin"]},"node_modules/@zed-industries/codex-acp-linux-arm64":{"version":"0.10.0","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-linux-arm64/-/codex-acp-linux-arm64-0.10.0.tgz","integrity":"sha512-tIm0uGKZuirZyqx9KAgIgh6cimVXdh+BMTFyUfH1xnez5Y3B6oFxzup/ZIP34OZ/W59Cnfi4wcIL3No0VV6Kmw==","cpu":["arm64"],"license":"Apache-2.0","optional":true,"os":["linux"]},"node_modules/@zed-industries/codex-acp-linux-x64":{"version":"0.10.0","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-linux-x64/-/codex-acp-linux-x64-0.10.0.tgz","integrity":"sha512-oiiN35wsecX1OwesV/KIu72o1OSw+OWFL86vQUUZTdfMXr9eyYFP1uZYLMxIx+tkhlJnm7KHC5L4raDg/MLVtA==","cpu":["x64"],"license":"Apache-2.0","optional":true,"os":["linux"]},"node_modules/@zed-industries/codex-acp-win32-arm64":{"version":"0.10.0","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-win32-arm64/-/codex-acp-win32-arm64-0.10.0.tgz","integrity":"sha512-dfybabjibQQpXUs9TjwLjg+mrj8tGSopVcwkFy8u3XG4hrBZVCri91dtVhm7hs98lZlawxwiiPuj4Pmg+4hHyQ==","cpu":["arm64"],"license":"Apache-2.0","optional":true,"os":["win32"]},"node_modules/@zed-industries/codex-acp-win32-x64":{"version":"0.10.0","resolved":"https://registry.npmjs.org/@zed-industries/codex-acp-win32-x64/-/codex-acp-win32-x64-0.10.0.tgz","integrity":"sha512-xCm3xsE3lD66DlbaLKBqHahPY1Lhb+rGu2IIq60qUsBGiYcSXtpRjQ1LXI/Sym6iCKrPo+eQP0j6rg7CPh1AGw==","cpu":["x64"],"license":"Apache-2.0","optional":true,"os":["win32"]}}}
    LOCKFILE
  '';
  npmDepsHash = "sha256-VR+unx99KlVazruEqYQ5fw6zO038YMdhBmXxEdgLvtU=";
  dontNpmBuild = true;
  meta = {
    description = "An ACP-compatible coding agent powered by Codex";
    homepage = "https://github.com/zed-industries/codex-acp";
    license = lib.licenses.asl20;
  };
}
