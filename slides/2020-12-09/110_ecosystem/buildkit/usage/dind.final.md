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
