let pkgs = import ./default.nix;
in
pkgs.mkShell {
  buildInputs = [
    pkgs.kustomize_3_9_2
    pkgs.kustomize_3_9_3
    pkgs.kustomize_4_5_7
    pkgs.kustomize_3_10_patched
  ];
}
