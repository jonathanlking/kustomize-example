This repo attempts to provide a minimal example of a change in behaviour between two
versions of the [kustomize](https://github.com/kubernetes-sigs/kustomize) tool.

This issue is tracked at
https://github.com/kubernetes-sigs/kustomize/issues/5047.

A `nix-shell` is provided for convenience, which provides binary versions of kustomize
suffixed with the version (e.g. `kustomize_3.9.2`) as well as
[`kustomize_3`](https://github.com/NixOS/nixpkgs/blob/nixos-22.11/pkgs/development/tools/kustomize/3.nix)
(v3.10) with a patched `PrefixesSuffixesEquals` function (see
https://github.com/kubernetes-sigs/kustomize/issues/5047#issuecomment-1470559774).
