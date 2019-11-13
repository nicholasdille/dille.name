## Docker CLI Plugins

Extend `docker` CLI with new sub commands

Located in `~/.docker/cli-plugins`

Executable file called `docker-<command>`

Command line parameters are passed as parameters

Plugin metdata via parameter `docker-cli-plugin-metadata`:

```json
{
"SchemaVersion":"0.1.0",
"Vendor":"Nicholas Dille",
"Version":"0.0.1",
"ShortDescription":"Sample metadata",
"URL":"https://dille.name"
}
```

--

## Demo: Docker CLI Plugins

Place `docker-distribution` in `~/.docker/cli-plugins`:

```bash
mkdir -p ~/.docker/cli-plugins
cp docker-distribution ~/.docker/cli-plugins
chmod +x ~/.docker/cli-plugins/docker-distribution
```

Test integration into Docker CLI:

```bash
docker
```

Display help for sub commands:

```bash
docker distribution
```

--

## Demo: Docker CLI Plugins

Prepare local registry:

```bash
docker pull alpine
docker tag alpine localhost:5000/alpine
docker login localhost:5000
docker push localhost:5000/alpine
```

Use docker-distribution to determine tags:

```bash
docker distribution list-tags localhost:5000/alpine
```

--

## Docker Client Plugins Manager (CLIP)

[CLIP](https://github.com/lukaszlach/clip) created by [Docker Captain Łukasz Lach](https://www.docker.com/captains/%C5%82ukasz-lach)

### How it works

Framework for running containerized client plugins

Distributed using Docker registry

### Plugin list

expose, publish, showcontext, microscan, dive, runlike, sh, hello

--

## Demo: Docker Client Plugins Manager (CLIP)

Install plugin for `dive`:

```bash
docker clip add lukaszlach/clips:dive
docker clip ls
```

Run plugin dive:

```bash
docker dive localhost:5000/alpine
```
