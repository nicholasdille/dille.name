## `docker context`

Manage connections to Docker instances

Like `docker-machine` without the deployment

Supports remoting via SSH

Check pre-defined context:

```plaintext
docker context ls
```

---

## Demo: `docker context` <i class="far fa-folder-open tooltip"><span class="tooltiptext tooltip-right">020_advanced/090_docker_context</span></i>

Start DinD container:

```plaintext
docker run -d --name dind --privileged \
    --publish 127.0.0.1:12376:2376 docker:dind
```

Copy certificates:

```plaintext
mkdir -p dind-certs
docker cp dind:/certs/client dind-certs
```

Create context:

```plaintext
docker context create dind \
    --docker 'host=tcp://127.0.0.1:12376,ca=dind-certs/client/ca.pem,cert=dind-certs/client/cert.pem,key=dind-certs/client/key.pem'
```

Set default context:

```plaintext
docker context use dind
docker context ls
docker version
```
