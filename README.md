# raspberry-k8s-config

This is my personal configuration for setting up k3s Clusters on my Raspberry Pis. It includes setting up the
master node and several worker nodes. Note that this is a personal project, which means that there are several
hardcoded values that are specific to my personal networking configuration (specifically the MASTER_NODE_IP).

## Setting up your Raspberry Pi

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

In each case, you'll need to modify `/boot/firmare/cmdline.txt` to include the following:

```shell
cgroup_memory=1 cgroup_enable=memory

# then reboot
sudo reboot
```

## Set up your Kubernetes Cluster

In this section, you will set up a fully functional k3s cluster on your Raspberry Pi. First, clone this repository:

```shell
git clone https://github.com/twaslowski/rpi-config.git && cd rpi-config
```

Next, you're going to install k3s and enable it as a systemd service so it will automatically start upon reboots.
This will give you a master node; if you're running just one Raspberry Pi, this is all you need.

```shell
# Master node setup
source bootstrap.sh
bootstrap_master
```

### Configure Kubectl

```shell
mkdir -p $HOME/.kube/k3s
touch $HOME/.kube/k3s/config
chmod 600 $HOME/.kube/k3s/config
sudo cat /etc/rancher/k3s/k3s.yaml > $HOME/.kube/k3s/config
```


### Setting up a worker node

If you have another machine that you would like to use as a worker node, you can use the following commands
to set it up to join your cluster. You'll need to retrieve the node-token from your master node first and then
execute the `bootstrap_worker` function on your worker node.

```shell
# Read the token on the master node
sudo cat /var/lib/rancher/k3s/server/node-token

# On the worker node, use the token to set it up to join the cluster
source bootstrap.sh
bootstrap_worker worker-node-1 <TOKEN>
```

## Documentation Backlog

- [x] Bootstrap a k3s cluster on a Raspberry Pi
- [x] Add a worker node to the cluster
- [ ] Traffic forwarding via Cloudflare Tunnel
- [ ] Prometheus & Grafana setup