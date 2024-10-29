# raspberry-k8s-config

This is my personal configuration for setting up k3s Clusters on my Raspberry Pis. It includes setting up the
master node and several worker nodes. Note that this is a personal project, which means that there are several
hardcoded values that are specific to my personal networking configuration (specifically the MASTER_NODE_IP).

## Usage

```
# Master node setup
. bootstrap.sh
bootstrap_master
```

This will  give you a k3s cluster master node and a token for setting up worker nodes.

```
# Worker node setup
. bootstrap.sh
bootstrap_worker worker-node-1 <TOKEN>
```