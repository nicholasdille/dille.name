---
title: 'Enable serving certificates for kubelet'
layout: snippet
tags:
- kubernetes
---
Kubelet uses serving certificates created from a separate certificate authority. Enabling serving cetificates signed by the cluster CA is work in progress as per [kubernetes/kubeadm#1223](https://github.com/kubernetes/kubeadm/issues/1223).

The following workaround can be used to enable serving certificates for kubelet but has the multiple caveats:
- Each kubelet creates a dedicated CSR for its serving certificate. This CSR must be approved manually
- The serving certificate is not automatically renewed. After nearly one year, a new CSR is created and must be approved manually (again)

1. Deploy a cluster and add `serverTLSBootstrap: true` to the kubelet configuration, e.g. using `kind`:

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: KubeletConfiguration
    serverTLSBootstrap: true
- role: worker
- role: worker
```

1. Approve the kubelet serving certificate signing requests:

```bash
kubectl --namespace=kube-system get csr --output=json \
| jq --raw-output '.items[] | select(.spec.signerName == "kubernetes.io/kubelet-serving") | .metadata.name' \
| xargs -I{} kubectl certificate approve {}
```

Mind the caveats listed above!
