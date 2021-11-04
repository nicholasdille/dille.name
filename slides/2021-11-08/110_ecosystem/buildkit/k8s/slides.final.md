<!-- .slide: class="center" style="text-align: center; vertical-align: middle" -->

## Remote builders

--

## BuildKit and Kubernetes

BuildKit can be used as a build service in Kubernetes

Multiple [examples available](https://github.com/moby/buildkit/tree/master/examples/kubernetes)

### Pod

Proof-of-concept

BuildKit understands the schema `kube-pod://`

### Deployment

Multiple pods can run simultaneously

Build is passed to any one of them by the service

### CLI

`buildx` comes with options to deploy BuildKit based pods

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

Wait for pod to deploy:

```plaintext
watch kubectl get pods
```

--

## Managing BuildKit using buildx

Configure buildx to use Kubernetes:

```plaintext
docker buildx create \
    --name k8s \
    --driver kubernetes \
    --driver-opt replicas=2 \
    --driver-opt rootless=true \
    --driver-opt loadbalance=random \
    --use
```

Deploy builder instances in Kubernetes:

```plaintext
docker buildx inspect k8s --bootstrap
```

Build using Kubernetes:

```plaintext
docker buildx build .
```
