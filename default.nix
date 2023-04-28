let
  baseNixpkgs = builtins.fetchTarball {
    name = "nixos-22.11";
    url = https://github.com/NixOS/nixpkgs/archive/4d2b37a84fad1091b9de401eb450aae66f1a741e.tar.gz;
    sha256 = "11w3wn2yjhaa5pv20gbfbirvjq6i3m7pqrq2msf0g7cv44vijwgw";
  };

  overlay = self: super: {
    kustomize_3_9_2 = self.callPackage ./nix/kustomize_binary.nix {
      version = "3.9.2";
      sha256 = {
        darwin = "bQG+Ot7pywsRiYjd1IefyuV1uqC2IQg2wdCqg8kZlng=";
        linux = "9cdqcmy9J7dFh/zSgW6Gs/YnnYQEO37Tclv0ixvIyko=";
      };
    };
    kustomize_3_9_3 = self.callPackage ./nix/kustomize_binary.nix {
      version = "3.9.3";
      sha256 = {
        darwin = "WQm5UVM51vy18dbd1AarXGzvaXQlpqu8mtRlnVhfpNc=";
        linux = "FrQsrdzeNs/q/71Fm+3ANJ5m9S56+hIIPUYwsTWPCqU=";
      };
    };
    kustomize_4_5_7 = self.callPackage ./nix/kustomize_binary.nix {
      version = "4.5.7";
      sha256 = {
        darwin = "b9V+eO0MBrW92CdQxdxtD5kqe5JtEU/pS+Rten4ytjo=";
        linux = "cB48S/oU5MUg1IH99xMfkCUxv8ACy1Bi3PMSY6CccMk=";
      };
    };

    # Suggestion from https://github.com/kubernetes-sigs/kustomize/issues/5047#issuecomment-1470559774
    kustomize_3_10_patched = (super.callPackage "${super.path}/pkgs/development/tools/kustomize/3.nix" {
      buildGoModule = args: super.buildGoModule (args // {
        overrideModAttrs = _: {
          postInstall = ''
            pushd $out/sigs.k8s.io/kustomize/
            patch -p1 -i ${./PrefixesSuffixesEquals.patch}
            popd
          '';
        };
        vendorSha256 = "sha256-E00uxwRHe2L8tY3i2o/e0BavhNJcEdXKdXP07hifOC0=";
      });
    }).overrideAttrs (oldAttrs: {
      installPhase =
        ''
          ${oldAttrs.installPhase}
          mv "$out/bin/kustomize" "$out/bin/kustomize_patched"
        '';
    });
  };

  pkgs = import baseNixpkgs ({ overlays = [ overlay ]; });

in
pkgs
