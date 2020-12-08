## BuildKit in docker-compose

Works since docker-compose version 1.25.1

Requires `docker` to be present

Set `COMPOSE_DOCKER_CLI_BUILD=1` to use `docker` for builds

Set `DOCKER_BUILDKIT=1` to enable BuildKit

### Commands

Enable building using CLI:

```plaintext
export COMPOSE_DOCKER_CLI_BUILD=1
```

Enable BuildKit:

```plaintext
export DOCKER_BUILDKIT=1
```

Build using docker-compose:

```plaintext
docker-compose build
```
