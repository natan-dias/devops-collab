---
layout: post
title: Kubernetes Validate
subtitle: A quick way to validate YAML kubernetes manifests.
#cover-img: /assets/img/post-img/k8s.png
thumbnail-img: /assets/img/post-img/k8s.png
#share-img: /assets/img/path.jpg
tags: [devops, kubernetes, english posts, github]
gh-repo: natan-dias/devops-collab
gh-badge: [star, follow, watch]
---

This method is just an easy way to check folders and to validate your kustomization setup.


## Requirements

+ Python
+ [kustomize](https://kubectl.docs.kubernetes.io/installation/kustomize/binaries/)
+ [kubernetes-validate](https://github.com/willthames/kubernetes-validate)

## How to use

From Kubernetes-validate repo you can get the script to check your yaml files

Just run via CLI:

> kubernetes-validate [-h] [-k KUBERNETES_VERSION] [--strict] [--version]


You can select a KUBERNETES VERSION to check for a specific API version.

### Examples

```
$ kubernetes-validate -k 1.13.6 examples/kuard-extra-property.yaml
INFO  examples/kuard-extra-property.yaml passed against version 1.13.6
```

```
$ kubernetes-validate --strict examples/kuard-extra-property.yaml
ERROR examples/kuard-extra-property.yaml did not validate against version 1.16.0: spec.selector: Additional properties are not allowed ('unwanted' was unexpected)
```

