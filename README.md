# raspberry-k8s-config

This is my personal configuration for setting up k3s Clusters on my Raspberry Pis. It includes setting up the
master node and several worker nodes. Note that this is a personal project, which means that there are several
hardcoded values that are specific to my personal networking configuration (specifically the MASTER_NODE_IP).

## Setup

There's a few things you need to do before installing k3s. First, you need to have a Raspberry Pi with a fresh
installation of Raspberry Pi OS. You can find the installation instructions [here](https://www.raspberrypi.org/software/).

Next up, install git:

```
sudo apt install git
```

and ohmyzsh (optional, but recommended):

```shell
sudo apt install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Usage

```shell
# Master node setup
. bootstrap.sh
bootstrap_master
```

This will  give you a k3s cluster master node and a token for setting up worker nodes.

```shell
# Worker node setup
. bootstrap.sh
bootstrap_worker worker-node-1 <TOKEN>
```

## Documentation Backlog

- [x] Bootstrap a k3s cluster on a Raspberry Pi
- [x] Add a worker node to the cluster
- [ ] Traffic forwarding via Cloudflare Tunnel
- [ ] Prometheus & Grafana setup