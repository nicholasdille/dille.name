## `docker context`

Manage connections to Docker instances

Like `docker-machine` without the deployment

Supports remoting via SSH

Check pre-defined context:

```bash
docker context ls
```

--

## Demo: `docker context`

Create and use new context:

```bash
docker context create docker-hcloud \
    --description 'Remote@Hetzner' \
    --docker 'host=ssh://020advanced-090dockercontext'
docker context use docker-hcloud
docker context ls
```

Check connectivity:

```bash
docker version
```

Check remote host:

```bash
docker run --uts host alpine hostname
```
