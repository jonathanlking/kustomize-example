{ fetchurl, lib, stdenv, version, sha256 }:

stdenv.mkDerivation rec {
  name = "kustomize";

  os = if stdenv.isDarwin then "darwin" else "linux";

  src = fetchurl {
    url = "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${version}/kustomize_v${version}_${os}_amd64.tar.gz";
    sha256 = sha256.${os};
  };

  dontUnpack = true;

  installPhase =
    ''
      mkdir -p "$out/bin"
      tar -xzf "$src" -C "$out/bin"
      chmod +x "$out/bin/kustomize"
      mv "$out/bin/kustomize" "$out/bin/kustomize_${version}"
    '';
}
