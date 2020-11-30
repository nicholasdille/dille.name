## Creating a pod using Docker

### Definition

Pods consist of one or more containers

Containers in a pod share the network namespace

Pods are the smallest unit of deployment in Kubernetes

### Advantage

Containers in a pod behave like the same host

They can talk to each other using `localhost`

### Disadvantage

Docker does not handle pods natively

--

## Demo: Creating a pod 1/2

Create a pod:

```plaintext
docker run --name pod \
    --detach \
    alpine \
        sh -c 'while true; do sleep 10; done'
```

Add a registry:

```plaintext
docker run --name registry \
    --detach \
    --pid container:pod \
    --network container:pod \
    registry:2
```

--

## Demo: Creating a pod 2/2

Add Docker-in-Docker:

```plaintext
docker run --name dockerd \
    --detach \
    --pid container:pod \
    --network container:pod \
    --privileged \
    docker:stable-dind \
        dockerd \
            --host=tcp://0.0.0.0:2375
```

Using the pod:

```plaintext
docker run --interactive --tty \
    --pid container:pod \
    --network container:pod \
    docker:stable
```

--

## Alternative: Using docker-compose for pods 1/2

Share network namespace across services:

```yaml
version: "3.3"
services:
  pod:
    image: alpine
    command: [ "sh", "-c", "while true; do sleep 5; done" ]
  dind:
    image: docker:stable-dind
    command: [ "dockerd", "--host", "tcp://127.0.0.1:2375" ]
    privileged: true
    network_mode: service:pod
  registry:
    image: registry:2
    network_mode: service:pod
```

Do not scale!

--

## Alternative: Using docker-compose for pods 2/2

Even easier with YAML anchors:

```yaml
version: "3.4"
x-pod-template: &pod
  depends_on: [ "pod" ]
  network_mode: service:pod
services:
  pod:
    image: alpine
    command: [ "sh", "-c", "while true; do sleep 5; done" ]
  registry:
    <<: *pod
    image: registry:2
  dind:
    <<: *pod
    image: docker:stable-dind
    command: [ "dockerd", "--host", "tcp://127.0.0.1:2375" ]
    privileged: true
```
