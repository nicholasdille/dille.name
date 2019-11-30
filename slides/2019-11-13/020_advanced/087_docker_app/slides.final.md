## docker-app

### What it is

De facto standard is using `docker-compose` for apps

Package and distribute using container registry

Standalone binary in version <= 0.6

Docker CLI plugin in version >= 0.7

### Further reading

Workshop by [Docker Captain Michael Irwin](https://www.docker.com/captains/michael-irwin) @ [Docker Summit 2019](https://github.com/mikesir87/docker-summit-19-docker-app-workshop)

--

## docker-app: Preparation

This is an experimental CLI feature:

```bash
cp ~/.docker/config.json ~/.docker/config.json.bak
cat ~/.docker/config.json.bak | jq '. + {"experimental": "enabled"}' >~/.docker/config.json
```

--

## docker-app: Creation

Create an app stack in hello.dockerapp:

```bash
docker app init --compose-file docker-compose.yml hello
```

Add parameters `port` and `text`

Push to registry and check resulting app:

```bash
docker app push --tag localhost:5000/hello:1.0 hello
docker app inspect localhost:5000/hello:1.0
```

--

## docker-app: Deploy

Render app from registry:

```bash
docker app render localhost:5000/hello:1.0
```

Render app with custom parameter:

```bash
docker app render \
    --set text="hello containerconf" \
    localhost:5000/hello:1.0
```

--

## docker-app: Internals

Stored like an image

Check image manifest:

```bash
MANIFEST=$(curl -sH \
    "Accept: application/vnd.docker.distribution.manifest.v2+json" \
    http://localhost:5000/v2/hello/manifests/1.0)
```

Image configuration is boring:

```bash
CONFIG=$(echo "${MANIFEST}" | jq --raw-output '.config.digest')
curl -o - \
    http://localhost:5000/v2/hello/blobs/${CONFIG} | jq
```

Layer contains packaged app:

```bash
LAYER=$(echo "${MANIFEST}" | jq --raw-output '.layers[0].digest')
curl -o - \
    http://localhost:5000/v2/hello/blobs/${LAYER} | tar -tvz
```
