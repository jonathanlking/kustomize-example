let
  baseNixpkgs = builtins.fetchTarball {
    name = "nixos-22.11";
    url = https://github.com/NixOS/nixpkgs/archive/4d2b37a84fad1091b9de401eb450aae66f1a741e.tar.gz;
    sha256 = "11w3wn2yjhaa5pv20gbfbirvjq6i3m7pqrq2msf0g7cv44vijwgw";
  };

  overlay = self: _super: {
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
    kustomize_4_5_6 = self.callPackage ./nix/kustomize_binary.nix {
      version = "4.5.6";
      sha256 = {
        darwin = "S32sksjy3Tg2USdseNnm0oAx9Q83Ec2Yc0egjt8MgzU=";
        linux = "aALVSRfrWIf5xxAxxZ5oRcGkkME4gbBQ6mlZtxS0pDI=";
      };
    };
  };

  pkgs = import baseNixpkgs ({ overlays = [ overlay ]; });

in
pkgs
