## Control group (cgroups)

Kernel feature for resource management

Processes can have...

- limits
- reservations

Mostly used for CPU and memory

Exceeded memory limits result in out-of-memory (OOM) kills

Can be nested

Must be root to use cgroups v1

--

## Demo: Control groups (cgroups)

Start container with 10% CPU limit:

```plaintext
docker run -d --name nginx --cpus=".1" nginx
```

Show processes belonging to container cgroup:

```plaintext
ID=$(docker container inspect nginx | jq -r '.[].Id')
cat /sys/fs/cgroup/cpu/docker/${ID}/cgroup.procs
```

Show CPU period and quota:

```plaintext
cat /sys/fs/cgroup/cpu/docker/${ID}/cpu.cfs_period_us
cat /sys/fs/cgroup/cpu/docker/${ID}/cpu.cfs_quota_us
```

--

## Control groups v2

XXX

--

## Further reading

[cgroup Part 1](https://www.redhat.com/sysadmin/cgroups-part-one)

[cgroup Part 2](https://www.redhat.com/sysadmin/cgroups-part-two)

[cgroup Part 3](https://www.redhat.com/sysadmin/cgroups-part-three)
