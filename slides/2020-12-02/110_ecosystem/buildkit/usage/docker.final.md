## Demo: Docker

Docker CLI hides the details of using BuildKit

### Option 1: Enable BuildKit through the client

Control BuildKit usage from Docker CLI

```plaintext
export DOCKER_BUILDKIT=1
docker build .
```

### Option 2: Configure Docker daemon to use BuildKit

The Docker daemon can use BuildKit by default

```plaintext
$ cat /etc/docker/daemon.json
{
    "features": {
        "buildkit": true
    }
}
```

--

## Demo: Docker daemon containerized

Docker-in-Docker requires a privileged container...

...which is a severe security concern

Run Docker-in-Docker with local port publishing:

```plaintext
docker run --name dockerd \
    --detach \
    --privileged \
    --publish 127.0.0.1:2375:2375 \
    docker:stable-dind \
        dockerd \
            --host tcp://0.0.0.0:2375
```

Run local Docker CLI against daemon container:

```plaintext
docker --host tcp://127.0.0.1:2375 build .
```

--

## Demo: Docker fully containerized

Docker-in-Docker requires a privileged container...

...which is a severe security concern

Run Docker-in-Docker with local port publishing:

```plaintext
docker run --name dockerd \
    --detach \
    --privileged \
    --publish 127.0.0.1:2375:2375 \
    docker:stable-dind \
        dockerd \
            --host tcp://0.0.0.0:2375
```

Run containerized Docker CLI against daemon container:

```plaintext
docker run --interactive --tty \
    --network container:dockerd \
    --volume $PWD:/src \
    --workdir /src \
    docker:stable \
    docker --host tcp://127.0.0.1:2375 build .
```
