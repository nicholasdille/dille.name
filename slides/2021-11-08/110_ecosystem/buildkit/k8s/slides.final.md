<!-- .slide: id="builders" class="center" style="text-align: center; vertical-align: middle" -->

## Remote builders

---

## BuildKit and Kubernetes

BuildKit can be used as a [build service in Kubernetes](https://github.com/moby/buildkit/tree/master/examples/kubernetes)

### Pod

BuildKit understands the schema `kube-pod://`

### Deployment

Load balancing works

### CLI

`buildx` comes with options to deploy BuildKit based pods

---

## Demo: BuildKit and Kubernetes <i class="far fa-folder-open tooltip"><span class="tooltiptext tooltip-right">110_ecosystem/buildkit/k8s</span></i>

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

Run build:

```plaintext
export BUILDKIT_HOST=kube-pod://buildkitd
buildctl build \
    --frontend=dockerfile.v0 \
    --local context=. \
    --local dockerfile=.
```

---

## Demo: Managing BuildKit using `buildx` <i class="far fa-folder-open tooltip"><span class="tooltiptext tooltip-right">110_ecosystem/buildkit/k8s</span></i>

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

---

## Demo: Making `buildx`the default builder

```bash
docker buildx install
```

`uninstall` to revert

Must push during build:

```bash
docker build --tag X --push .
```

`docker push` and `docker tag` do not work

Similar but not identical DX
