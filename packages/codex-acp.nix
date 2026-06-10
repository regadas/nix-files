{ pkgs, lib, ... }:

let
  version = "0.16.0";
  binaryPackages = {
    darwin-arm64 = {
      cpu = [ "arm64" ];
      os = [ "darwin" ];
      executable = "bin/codex-acp";
      integrity = "sha512-2AmbWsc/+Mpn6U8UOIlPLvgwGsGOr/LFpgcvrnjcCT9V1yY92MLrqzjMX82+VjTrRLRuXvc25SB5Z1++4Pw29g==";
    };
    darwin-x64 = {
      cpu = [ "x64" ];
      os = [ "darwin" ];
      executable = "bin/codex-acp";
      integrity = "sha512-QCWggk0s4GTPLCR7eznyx29Dls4gzUKvp4MjZ4nzPX5gDL/02PGY+oCV1WsQOsnzWRK0RxM+GlK19rG1qzqplw==";
    };
    linux-arm64 = {
      cpu = [ "arm64" ];
      os = [ "linux" ];
      executable = "bin/codex-acp";
      integrity = "sha512-8HaZGWVPVs1N6yqImLCKlnlcYTYc9BMCEhaVJk0ON9lyofhK9mOBBAHQndKC4Scqq5JLUHQIOyb8+jwHUe3hSQ==";
    };
    linux-x64 = {
      cpu = [ "x64" ];
      os = [ "linux" ];
      executable = "bin/codex-acp";
      integrity = "sha512-xs5zZBLpJuciEbZNx6ZSNL0qCa9h3i/zWpj40sp6QtF+L4Ow/7qzHdBzboGhHdcz1jrLedfZeRFDA2Elj8TLMA==";
    };
    win32-arm64 = {
      cpu = [ "arm64" ];
      os = [ "win32" ];
      executable = "bin/codex-acp.exe";
      integrity = "sha512-4V3pDJvEyNkgVqWqlm0bLYEZ8liGXXp8InuHzCy5cgr+SFur6BuasA29tisN8NUrLus/ZvMhXCrOsNKurYAWQw==";
    };
    win32-x64 = {
      cpu = [ "x64" ];
      os = [ "win32" ];
      executable = "bin/codex-acp.exe";
      integrity = "sha512-ZriI/ay5E3DCg8s22LZykIRI2XzQL6sZg/t81K+6qc86ldscaSWQSOT6KSnRcv31QJCMfBlFxMj22pZiGSVjQA==";
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
    hash = "sha256-LeD3nHvRWX4ZgZ3/fVngDcR6/LtaY4eb2M2WmWaymlY=";
  };
  sourceRoot = "${src.name}/npm";
  postPatch = ''
    cp ${packageLockFile} package-lock.json
  '';
  npmDepsHash = "sha256-QLiywaicKcVGTDwcNzVCI5/NnOWMteCLeaye5LtxINo=";
  dontNpmBuild = true;
  meta = {
    description = "An ACP-compatible coding agent powered by Codex";
    homepage = "https://github.com/zed-industries/codex-acp";
    license = lib.licenses.asl20;
  };
}
