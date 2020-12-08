## BuildKit and Kubernetes

BuildKit can be used as a build service in Kubernetes

Multiple [examples available](https://github.com/moby/buildkit/tree/master/examples/kubernetes)

### Pod

Proof-of-concept

BuildKit understands the schema `kube-pod://`

### Deployment

Multiple pods can run simultaneously

Build is passed to any one of them by the service

--

## Demo: BuildKit and Kubernetes

Pass build to remote pod

Create cluster:

```plaintext
kind create cluster
```

Run BuildKit daemon:

```plaintext
kubectl apply -f pod.rootless.yaml
```

Run build:

```plaintext
export BUILDKIT_HOST=kube-pod://buildkitd
buildctl build \
    --frontend=dockerfile.v0 \
    --local context=. \
    --local dockerfile=.
```
