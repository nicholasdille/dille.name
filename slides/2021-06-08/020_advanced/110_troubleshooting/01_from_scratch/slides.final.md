## Troubleshooting `FROM scratch`
<!-- .slide: id="debug_from_scratch" -->

### Missing tools

Many containers only contain a single binary

No shell, no tools

### Solution

Dump root partition content into container

--

## Demo: Troubleshooting `FROM scratch`

Container with image FROM scratch:

```plaintext
docker run -d --name traefik traefik:v1.7
```

Create local rootfs:

```plaintext
mkdir rootfs
docker create --name alpine alpine
docker cp alpine:/ rootfs
```

Copy into container:

```plaintext
rm rootfs/etc/hosts rootfs/etc/hostname rootfs/etc/resolv.conf
cd rootfs && docker cp . traefik:/ && cd ..
```

Enter container:

```plaintext
docker exec -it traefik /bin/sh
```
