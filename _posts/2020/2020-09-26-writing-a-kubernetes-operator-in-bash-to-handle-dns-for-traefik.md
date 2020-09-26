---
title: 'Writing a #Kubernetes controller in #bash to handle DNS for #traefik'
date: 2020-09-26T09:44:00+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2020/09/26/writing-a-kubernetes-controller-to-handle-dns-for-traefik/
categories:
  - Haufe-Lexware
tags:
- Container
- Docker
- Kubernetes
- traefik
---
I am using traefik as the ingress controller in multiple Kubernetes clusters. Those instances are running standalone (without the integrated high availability). To make sure that users are able to reach traefik, a DNS record points to the host IP. So far, an init container was responsible for updating DNS if the traefik pod restarts. But recently I decided to decouple the DNS update from traefik. This led to writing a Kubernetes controller to watch the traefik pod for restarts and update DNS accordingly. This post provides details about writing the controller in bash.

<img src="/media/2020/09/analysis-4402809_1920.jpg" style="object-fit: cover; object-position: bottom; width: 100%; height: 250px;" />

<!--more-->

## Receiving Kubernetes events

Events can be displayed on the command line using `kubectl`:

```bash
kubectl get pods --selector ${LABEL_SELECTOR} --watch --output-watch-events
```

When adding `--output json` these events are shown in JSON and can be processed by script logic:

```bash
kubectl get pods --selector ${LABEL_SELECTOR} --watch --output-watch-events --output json | while read EVENT; do
    # my code
done
```

The events contains a type in `.type` as well as the object in `.object`:

```json
{
  "type": "ADDED",
  "object": {}
}
```

Events can have one of the types `ADDED`, `MODIFIED` and `DELETED`.

When a service like traefik is restarted, the pod is removed and a new pod is created. Kubernetes produces multiple events to follow the state of the old as well as the new object as they are terminated and scheduled.

Note: I do not know why but `jq` is not able to parse the JSON provided by `kubectl` unless I remove managed fields (`.metadata.managedFields`):

```bash
kubectl get pods --selector ${LABEL_SELECTOR} --watch --output-watch-events --output json | \
    jq --compact-output --monochrome-output --unbuffered 'del(.object.metadata.managedFields)' | \
    while read EVENT; do
        # my code
done
```

## `traefik-dns`

I have published [my code for `traefik-dns` on GitHub](https://github.com/nicholasdille/traefik-dns). It follows pods in a specific namespace and using a label selector and relies on [`external-dns`](https://github.com/kubernetes-sigs/external-dns) to update DNS.

It works in the following way:

1. It follows a specific pod specified by namespace and label selector
1. The controller runs in an endless loop to process events
1. When the controller starts it receives an event of the type `ADDED` representing the current state (when the pod exists)
1. The control loop processes events to follow the termination of the pod
1. When a new pod is scheduled the events are also followed
1. As soon as the new pod is running, the control loop calls a handler to update a `DNSEndpoint` object

The project is in just a proof of concept. Do not use it in production.

## Alternative: `shell-operator`

After finishing the first version of `traefik-dns` I came across [`shell-operator`](https://github.com/flant/shell-operator). This allows to focus on the task at hand instead of implementing the control loop myself. I will take a closer look at it and update `traefik-dns` to use `shell-operator`.
