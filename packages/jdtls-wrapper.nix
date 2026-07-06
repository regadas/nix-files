{ pkgs, lib, ... }:

# Proxy that sits between Helix and jdtls so `gd` (go-to-definition) works for
# Java *dependencies*, not just project files. jdtls returns `jdt://` URIs for
# compiled classes; Helix cannot open that scheme ("unsupported scheme 'jdt'").
# This wrapper intercepts those responses, requests `java/classFileContents`,
# writes the decompiled source under /tmp, and hands Helix a plain `file://`
# URI. Requires `extendedClientCapabilities.classFileContentsSupport = true`
# in the jdtls server config (set in home-manager.nix).
pkgs.buildGoModule rec {
  pname = "jdtls-wrapper";
  version = "25.11.1";

  src = pkgs.fetchFromGitHub {
    owner = "quantonganh";
    repo = "jdtls-wrapper";
    rev = version; # git tag == version
    hash = "sha256-5TOdb1TMHytyVAoD/rnY/173KZZRGJa5DA11DApTTGo=";
  };

  # Single-file, standard-library-only program: no external Go modules.
  vendorHash = null;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  # The wrapper shells out to `jdtls` on PATH; guarantee it can always find the
  # same server binary we ship, independent of the caller's environment.
  postInstall = ''
    wrapProgram $out/bin/jdtls-wrapper \
      --prefix PATH : ${lib.makeBinPath [ pkgs.jdt-language-server ]}
  '';

  meta = {
    description =
      "jdtls proxy translating jdt:// URIs to file:// so Helix can go-to-definition into Java dependencies";
    homepage = "https://github.com/quantonganh/jdtls-wrapper";
    license = lib.licenses.mit;
    mainProgram = "jdtls-wrapper";
  };
}
