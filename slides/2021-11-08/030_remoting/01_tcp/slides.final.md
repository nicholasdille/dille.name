## TCP Remoting

Docker Engine API can be published on TCP port

Unfortunately, too easy to publish without authentication

Certificate based server and client authentication is painful

Insecure `dockerd` enables host breakout

### Recommendation

Do not open TCP without authentication

More later!

---

## Demo: TCP Remoting <i class="far fa-folder-open tooltip"><span class="tooltiptext tooltip-right">030_remoting/01_tcp</span></i>

Test containerized

Run container with Docker:

```plaintext
docker run --name tcp \
    --detach \
    --privileged \
    --publish 127.0.0.1:2375:2375 \
    docker:dind \
        dockerd --host tcp://0.0.0.0:2375
```

Use remote Docker over TCP:

```plaintext
docker --host tcp://:2375 version
```

Define remote Docker using environment variable:

```plaintext
export DOCKER_HOST=tcp://:2375
docker version
```
