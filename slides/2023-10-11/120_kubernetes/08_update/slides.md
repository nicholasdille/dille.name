## Updating pods

![Create, scale, update, recover, remove](120_kubernetes/08_update/lifecycle.drawio.svg) <!-- .element: style="float: right; width: 8em;" -->

ReplicaSets are only responsible for maintaining scale

Containerized services require complete lifecycle management

Update without service interruption

### Deployments

Responsible for updating applications with multiple replicas

### Strategies

`RollingUpdate` - Bring up new replicas as early as possible

`Recreate` - Start new replica after old replica was removed

---

## Deployment internals

![Deployment with ReplicaSet and pods](120_kubernetes/08_update/replicaset.drawio.svg) <!-- .element: style="float: right; padding-left: 1em; width: 25%;" -->

### Hidden ReplicaSet

Deployments create a ReplicaSet

ReplicaSet maintains scale

ReplicaSet receives a random suffix

Pods receive a second random suffix

![Deployment with old and new ReplicaSet](120_kubernetes/08_update/updates.drawio.svg) <!-- .element: style="float: right; padding-left: 1em; width: 20%;" -->

### Updates

Deployments initiate an update by creating a new ReplicaSet

Updates work by scaling the new ReplicaSet up...

...and scaling the old ReplicaSet down
