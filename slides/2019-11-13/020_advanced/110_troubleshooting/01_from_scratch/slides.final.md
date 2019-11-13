## Troubleshooting `FROM scratch`

### Missing tools

- Modern containers only contain a single binary
- No shell, no tools

### Solution: Dump root partition content into container

--

## Demo: Troubleshooting `FROM scratch`

Container with image FROM scratch:

```bash
docker run -d --name traefik traefik:v1.7
```

Create local rootfs:

```bash
mkdir rootfs
docker create --name alpine alpine
docker cp alpine:/ rootfs
```

Copy into container:

```bash
rm rootfs/etc/hosts rootfs/etc/hostname rootfs/etc/resolv.conf
cd rootfs && docker cp . traefik:/ && cd ..
```

Enter container:

```bash
docker exec -it traefik /bin/sh
```
