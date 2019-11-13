## Image building

### kaniko

- [Kaniko](https://github.com/GoogleContainerTools/kaniko) created by Google
- Daemonless, unprivileged
- Uses Dockerfile

### buildah

- [Buildah](https://github.com/containers/buildah) created by RedHat
- Daemonless, unprivileged
- Script/command based (not using Dockerfile)

### img

- [img](https://github.com/genuinetools/img) created by [Jessie Frazelle](https://blog.jessfraz.com/)
- Based on buildkit
- Daemonless, unprivileged
- Uses Dockerfile

--

## Demo: img

Building and pushing using `img`

Enter pod:

```bash
docker exec -it img bash
```

Build image:

```bash
img build --tag localhost:5000/test .
```

Push image:

```bash
img push --insecure-registry localhost:5000/test
```
