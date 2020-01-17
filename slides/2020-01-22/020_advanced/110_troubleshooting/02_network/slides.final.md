## Troubleshooting Networking

### Missing tools

- Images are minimal
- Shell is available
- Containers are considered immutable

### Share namespaces

- Create container image with required tools
- Run and share network/pid namespace
- Install tools as required

k8s 1.16 introduces [ephemeral containers](https://kubernetes.io/docs/concepts/workloads/pods/ephemeral-containers/) to troubleshoot pods

--

## Demo: Namespace sharing

Run container which needs troubleshooting:

```bash
docker run -d --name nginx nginx
```
