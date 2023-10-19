---
title: 'Parsing complex data structures using #jq'
date: 2023-10-19T21:02:00+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2023/10/19/parsing-complex-data-structures-using-jq/
categories:
- Haufe-Lexware
tags:
- jq
- Prometheus
- Monitoring
- Kubernetes
- k8s
---
When working with infrastructure-as-code, you have process data structures to filter, extract or transform data. How such a task develops is highly dependent on the complexity of the data structures as well as the level of nested arrays and hashes. This post shows you examples how to use [yq](https://github.com/mikefarah/yq) and [jq](https://github.com/jqlang/jq) to parse them.

<img src="/media/2023/10/elena-mozhvilo-Lp9uH9s9fss-unsplash.jpg" style="object-fit: cover; object-position: center 45%; width: 100%; height: 200px;" />

<!--more-->

## Creating Prometheus metrics from nested YAML

Iamgine your management has adopted YAML for the latest project called "company-as-code". The following YAML file describes the floor plan of your company with the seats reserved for the different teams:

```yaml
buildings:
- building: A
  floors:
  - floor: 0
    plan:
    - team: FOO
      seats: 20
  - floor: 1
    plan:
    - team: BAR
      seats: 25
- building: B
  floors:
  - floor: 0
    plan:
    - team: BAZ
      seats: 20
  - floor: 1
    plan:
    - team: BLARG
      seats: 25
```

Your task is to transform this into Prometheus metrics so that you can monitor the utilization of the floor plan. It is rather difficult to access values from high fields when plunging into the deeper levels of YAML/JSON. The following `jq`` expression will transform the YAML:

```bash

```bash
yq --output-format=json eval . plan.yaml \
| jq --raw-output '
    .buildings[] | .building as $building |
        .floors[] | .floor as $floor |
            .plan[] | 
                "plan{building=\"\($building)\",floor=\"\($floor)\",team=\"\(.team)\"} \(.seats)"
'
```

As soon as `.buildings[]` is expanded, the name of the building - from `.building` - is stored in `$building` for later use. The same applies to the floor. As soon as the array `plan` is expanded the variables declared earlier can be used to include the name of the building as well as the floor:

You can also simplify this by using [gojq](https://github.com/itchyny/gojq):

```bash
gojq --yaml-input --raw-output '.' plan.yaml
```

## Selecting elements based on deeper properties

In this second case you are tasked with filtering pods based on their readiness. The following expression will select the names of all pods that are ready:

```bash
kubectl get pods --output=json \
| jq --raw-output '
    .items[] | . as $pod |
        .status.conditions[] |
            select(.type == "Ready" and .status == "True") | 
                $pod.metadata.name
'
```

The tricky part of this expression is the selection of pods based on array items deeper down in the data structure. It is important to store the current pod in `$pod` so it can be referenced later on. This allows the conditions in `.status.conditions[]` to be filtered using `select()`. The metadata of the pod can be returned by using the variable `$pod` declared earlier.
