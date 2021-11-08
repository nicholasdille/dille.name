## Namespaces

Primary isolation feature used for containers

Processes can be isolated in the following namespaces:

- `pid` for process IDs
- `mnt` for mountpoints
- `uts` for hostname (Unix Timesharing Systems)
- `ipc` for inter-process communication
- `net` for networking

Containers isolate all namespaces by default

Can be nested

---

## Demo: Namespaces <i class="far fa-folder-open tooltip"><span class="tooltiptext tooltip-right">020_advanced/170_kernel</span></i>

- Show namespaces created by Docker
- Enter existing namespaces
- Create custom namespaces

See `namespaces.demo`

(Very extensive and does not fit on a slide.)

---

## Demo: Sharing namespaces <i class="far fa-folder-open tooltip"><span class="tooltiptext tooltip-right">020_advanced/170_kernel</span></i>

The nginx container image does not contain `ps`

Run `nginx` container:

```plaintext
docker run -d --name web nginx
```

Check for `ps` (missing):

```plaintext
docker exec -it web \
    whereis ps
```

Share PID namespace to use `ps`:

```plaintext
docker run -it --rm --pid container:web ubuntu:hirsute \
    ps fauxww
```

The same works for other namespaces

---

## Further reading

https://www.nginx.com/blog/what-are-namespaces-cgroups-how-do-they-work/

https://www.redhat.com/sysadmin/building-container-namespaces

https://www.redhat.com/sysadmin/pid-namespace

https://www.redhat.com/sysadmin/mount-namespaces

https://www.redhat.com/sysadmin/container-namespaces-nsenter
