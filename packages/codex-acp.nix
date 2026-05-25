{ pkgs, lib, ... }:

let
  version = "0.15.0";
  binaryPackages = {
    darwin-arm64 = {
      cpu = [ "arm64" ];
      os = [ "darwin" ];
      executable = "bin/codex-acp";
      integrity = "sha512-9/tnj1fXeXIONgr+5FGwr3bkqd4jaORdr3X9/k++rzHW+UIzvgIeXrJKv43403gtuKp0BoxdzsFxe2qsAQhhkw==";
    };
    darwin-x64 = {
      cpu = [ "x64" ];
      os = [ "darwin" ];
      executable = "bin/codex-acp";
      integrity = "sha512-2cmflnVYM5yzvNu4ldff6OsfLzQThFToPszCT3t7jytWuG28V+W1cUEGsvFJGNkGC1Wo29Z4w5LZ3wyfOkvPxg==";
    };
    linux-arm64 = {
      cpu = [ "arm64" ];
      os = [ "linux" ];
      executable = "bin/codex-acp";
      integrity = "sha512-ioCXCiZMd4v7Eqyed9Iz4xcPKsZbSH157wOitsWQKxUiX43c1Ti5fykZcrh9cNSLOgiGmI3V2nbYp0aTf66grQ==";
    };
    linux-x64 = {
      cpu = [ "x64" ];
      os = [ "linux" ];
      executable = "bin/codex-acp";
      integrity = "sha512-WtqI8KGX9z7XvdkazumYraoDwpip5lFBRtFXoIwYCSBoDZdOqQsfNQndIfTDttfQ1BdZYKczDnrfbRaiIFU9UA==";
    };
    win32-arm64 = {
      cpu = [ "arm64" ];
      os = [ "win32" ];
      executable = "bin/codex-acp.exe";
      integrity = "sha512-L+OFIPOzAuxsImlq8E227MZxgujMLMEJSqiR9QjZq8fiIFCKh/HnxmvyXvjWaHbJdb1pZ09WKe3MNwV9ln/+GQ==";
    };
    win32-x64 = {
      cpu = [ "x64" ];
      os = [ "win32" ];
      executable = "bin/codex-acp.exe";
      integrity = "sha512-LDnADpCg1Rzbkyxs4hMaOvRwNa68KLp8CoNVom8ZE/sChSvcDrj/RCoMsZWrARJGWs7EQ9zYeLoeVk5VcVQoPQ==";
    };
  };

  packageName = "@zed-industries/codex-acp";
  binaryPackageName = target: "${packageName}-${target}";
  packageLockFile = pkgs.writeText "codex-acp-package-lock.json" (builtins.toJSON {
    name = packageName;
    inherit version;
    lockfileVersion = 3;
    requires = true;
    packages = {
      "" = {
        name = packageName;
        inherit version;
        license = "Apache-2.0";
        bin.codex-acp = "bin/codex-acp.js";
        optionalDependencies = lib.mapAttrs'
          (target: _: {
            name = binaryPackageName target;
            value = version;
          })
          binaryPackages;
      };
    } // lib.mapAttrs'
      (target: package: {
        name = "node_modules/${binaryPackageName target}";
        value = {
          inherit version;
          resolved = "https://registry.npmjs.org/${binaryPackageName target}/-/${baseNameOf (binaryPackageName target)}-${version}.tgz";
          inherit (package) cpu integrity os;
          license = "Apache-2.0";
          optional = true;
          bin.${baseNameOf (binaryPackageName target)} = package.executable;
        };
      })
      binaryPackages;
  });
in
pkgs.buildNpmPackage rec {
  pname = "codex-acp";
  inherit version;
  src = pkgs.fetchFromGitHub {
    owner = "zed-industries";
    repo = "codex-acp";
    rev = "v${version}";
    hash = "sha256-XSy0qJudzt5ZN9TWQsWhKvfKkPBPAH7vF1RV96P268w=";
  };
  sourceRoot = "${src.name}/npm";
  postPatch = ''
    cp ${packageLockFile} package-lock.json
  '';
  npmDepsHash = "sha256-eqTjpOm9k/V2snOu0u0EJana8h/O87KhUfP2lh0jojg=";
  dontNpmBuild = true;
  meta = {
    description = "An ACP-compatible coding agent powered by Codex";
    homepage = "https://github.com/zed-industries/codex-acp";
    license = lib.licenses.asl20;
  };
}
