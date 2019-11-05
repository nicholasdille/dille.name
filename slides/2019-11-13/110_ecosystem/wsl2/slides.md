## Windows Subsystem for Linux v2

### Goals

- Improve file system performance
- Full system call compatibility

### Design

- WSL 2 runs a [Linux kernel maintained by Microsoft](https://github.com/microsoft/WSL2-Linux-Kernel) in a tiny VM
- Root file system is stored in `vhdx` file
- Runs in the same network as Windows

### Availability

- Windows 10 Insider Fast Ring (>= 10.18917)

--

## Demo: WSL 2

Run Docker locally:

```bash
sudo /etc/init.d/docker start
docker context ls
```

Shutdown tiny VM:

```bash
wsl --shutdown
```
