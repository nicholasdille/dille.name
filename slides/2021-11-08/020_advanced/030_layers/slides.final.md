<!-- .slide: id="layers" class="center" style="text-align: center; vertical-align: middle" -->

## Images and Layers

---

## Naming scheme

Format: `<registry>/<repository>:<tag>`

`<repository>` describes purpose

`<tag>` describes variant or version

`<repository>:<tag>` is called an image

### Docker Hub

On Docker Hub: `<repository>:<tag>`

Official image: `alpine:stable`

Community image: `nicholasdille/insulatr`

---

## Images and layers

Images consist of layers

Layers improve download performance

Layers enable reusability

---

## Image Manifest

Lists layers in the image

Layers are referenced as blobs

References are SHA256 hashed: `sha256:...`

### Image configuration

Contains command used to create layers

Stored as blob

![](020_advanced/030_layers/image.svg) <!-- .element: style="display: block; margin-left: auto; margin-right: auto;" -->

---

## Demo: Layers <i class="far fa-folder-open tooltip"><span class="tooltiptext tooltip-right">020_advanced/030_layers</span></i>

Upload image to local registry

Build and push image:

```plaintext
docker run -d -p 127.0.0.1:5000:5000 registry:2
docker build --tag localhost:5000/hello-world-java .
docker push localhost:5000/hello-world-java
```

Check layers:

```plaintext
docker history localhost:5000/hello-world-java
```

Analyze layers:

```plaintext
dive hello-world-java
```

https://github.com/wagoodman/dive

---

## Demo: Image Manifest <i class="far fa-folder-open tooltip"><span class="tooltiptext tooltip-right">020_advanced/030_layers</span></i>

Fetch image manifest:

```plaintext
curl http://localhost:5000/v2/hello-world-java/manifests/latest \
  --silent \
  --header "Accept: application/vnd.docker.distribution.manifest.v2+json" \
| jq
```

---

## Demo: Image Configuration <i class="far fa-folder-open tooltip"><span class="tooltiptext tooltip-right">020_advanced/030_layers</span></i>

Fetch image configuration:

```plaintext
DIGEST=$(
  curl http://localhost:5000/v2/hello-world-java/manifests/latest \
    --silent \
    --header "Accept: application/vnd.docker.distribution.manifest.v2+json" \
  | jq --raw-output '.config.digest'
)
curl http://localhost:5000/v2/hello-world-java/blobs/${DIGEST} \
  --silent \
  --header "Accept: application/vnd.docker.container.image.v1+json" \
| jq
```

---

## Demo: Download image layer <i class="far fa-folder-open tooltip"><span class="tooltiptext tooltip-right">020_advanced/030_layers</span></i>

Fetch digest of last layer:

```plaintext
DIGEST=$(
  curl http://localhost:5000/v2/hello-world-java/manifests/latest \
    --silent \
    --header "Accept: application/vnd.docker.distribution.manifest.v2+json" \
  | jq --raw-output '.layers[-1].digest'
)
```

View layer tarball:

```plaintext
curl http://localhost:5000/v2/hello-world-java/blobs/${DIGEST} \
  --silent \
  --header "Accept: application/vnd.docker.image.rootfs.diff.tar.gzip" \
| tar -tvz
```

---

## Demo: Verifying a layer <i class="far fa-folder-open tooltip"><span class="tooltiptext tooltip-right">020_advanced/030_layers</span></i>

Verifying a layer digest:

```plaintext
curl http://localhost:5000/v2/hello-world-java/blobs/${DIGEST} \
  --silent \
  --header "Accept: application/vnd.docker.image.rootfs.diff.tar.gzip" \
| sha256sum
```

Calculating a layer's length:

```plaintext
curl http://localhost:5000/v2/hello-world-java/blobs/${DIGEST} \
  --silent \
  --header "Accept: application/vnd.docker.image.rootfs.diff.tar.gzip" \
| wc -c
```

---

## Registries

[REST API](https://docs.docker.com/registry/spec/api/) and [Image Manifest Specification v2.2](https://docs.docker.com/registry/spec/manifest-v2-2/)

No UI

Manage images, layers, configurations

Upload, list, update, delete

### Usage

Registries are accessed using HTTPS

Insecure registries must be defined expicitly

Accepted insecure registry: `127.0.0.1/8`

---

## Demo: Registries <i class="far fa-folder-open tooltip"><span class="tooltiptext tooltip-right">020_advanced/030_layers</span></i>

### Tagging images remotely

Download existing manifest:

```plaintext
MANIFEST=$(
  curl http://localhost:5000/v2/hello-world-java/manifests/latest \
    --silent \
    --header "Accept: application/vnd.docker.distribution.manifest.v2+json"
)
```

Upload manifest to new path:

```plaintext
curl http://localhost:5000/v2/hello-world-java/manifests/new \
  --request PUT \
  --header "Content-Type: application/vnd.docker.distribution.manifest.v2+json" \
  --data "${MANIFEST}"
```
