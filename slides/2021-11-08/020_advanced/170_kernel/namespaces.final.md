## Namespaces

Primary isolation feature used for containers

Processes can be isolated in the following namespaces:

- `pid` for process IDs
- `mnt` for mountpoints
- `uts` for hostname (Unix Timesharing Systems)
- `ipc` for inter-process communication (POSIX message queue and System V IPC)
- `net` for networking

Containers isolate all namespaces by default

Can be nested

--

## Demo: Namespaces

- Show namespaces created by Docker
- Enter existing namespaces
- Create custom namespaces

See `namespaces.demo`

(Very extensive and does not fit on a slide.)

--

## Demo: Sharing namespaces

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

--

## Further reading

[The PID namespace](https://www.redhat.com/sysadmin/pid-namespace)

[The mount namespace](https://www.redhat.com/sysadmin/mount-namespaces)

[Building a Linux container by hand using namespaces](https://www.redhat.com/sysadmin/building-container-namespaces)
