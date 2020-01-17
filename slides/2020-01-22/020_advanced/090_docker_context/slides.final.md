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

--

## `docker context`

Manage connections to Kubernetes clusters

```bash
k3d create --name context --worker 3
KUBECONFIG=$(k3d get-kubeconfig --name=context)
docker context create k3d --docker 'host=unix:///var/run/docker.sock' --kubernetes config-file=${KUBECONFIG}
```
