This repo attempts to provide a minimal example of a change in behaviour between two
versions of the [kustomize](https://github.com/kubernetes-sigs/kustomize) tool.

The name in a `configMapRef` is not updated to include the hash as a suffix nor a
prefix (from a `namePrefix` transformer).

This behaviour appeared in `v3.9.3`, but can be reverted by applying the
`--enable_kyaml=false` flag and from looking at the release notes for
[`v3.9.3`](https://github.com/kubernetes-sigs/kustomize/releases/tag/kustomize%2Fv3.9.3)
I believe the difference is actually due to the switch to the `kyaml` library.

This new behaviour is still present in `v4.5.7`.

Curiously this behaviour is only present when then there are multiple resources
in the `example/kustomization.yaml` file. If you comment out either `a` or `b`
then the "correct"/expected `configMapRef` is given again.

I would like to answer two questions:

  1. What changes need to be made to the kustomization to get the old result back?
     (this minimal example is extracted from a real codebase that I'm stuck upgrading!)
  2. What is the correct behaviour? Was the change actually an (undocumented?) fix?

A nix shell is provided for convenience, which provides versions of kustomize
suffixed with the version (e.g. `kustomize_3.9.2`), however you can also just
manually download the published binaries from GitHub.

The example is run with `kustomize build example`.

`kustomize_3.9.2 build example`:

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: a-example-configmap-6ct58987ht
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: b-example-configmap-6ct58987ht
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: a-api
spec:
  template:
    spec:
      containers:
      - envFrom:
        - configMapRef:
            name: '-'
        - configMapRef:
            name: a-example-configmap-6ct58987ht
        name: app
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: b-api
spec:
  template:
    spec:
      containers:
      - envFrom:
        - configMapRef:
            name: '-'
        - configMapRef:
            name: b-example-configmap-6ct58987ht
        name: app
```

`kustomize_3.9.3 build example`:

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: a-example-configmap-6ct58987ht
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: b-example-configmap-6ct58987ht
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: a-api
spec:
  template:
    spec:
      containers:
      - envFrom:
        - configMapRef:
            name: '-'
        - configMapRef:
            name: -example-configmap
        name: app
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: b-api
spec:
  template:
    spec:
      containers:
      - envFrom:
        - configMapRef:
            name: '-'
        - configMapRef:
            name: -example-configmap
        name: app
```

The diff between the two is:

```diff
23c23
<             name: a-example-configmap-6ct58987ht
---
>             name: -example-configmap
38c38
<             name: b-example-configmap-6ct58987ht
---
>             name: -example-configmap
```
