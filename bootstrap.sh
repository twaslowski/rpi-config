#!/usr/bin/env bash

# Primarily sourced from https://ionutbanu.medium.com/kubernetes-on-raspberry-pi-5-part-3-install-k3s-on-master-node-f95ea35a8b1c

function bootstrap_master() {
    echo "Setting up k3s cluster on master node"
    export K3S_NODE_NAME="master-node"
    export MASTER_NODE_IP="192.168.178.100"
    export K3S_KUBECONFIG_MODE="600"
    export INSTALL_K3S_EXEC="server --node-ip=$MASTER_NODE_IP \
                                    --bind-address=$MASTER_NODE_IP \
                                    --advertise-address=$MASTER_NODE_IP \
                                    --flannel-backend=host-gw \
                                    --disable=servicelb \
                                    --disable=traefik \
                                    --disable-cloud-controller \
                                    --disable-helm-controller \
                                    --cluster-init"

    curl -sfL https://get.k3s.io | sh -

    echo "Setup successful. Here's the token for setting up worker nodes:"
    sudo cat /var/lib/rancher/k3s/server/node-token
}

function bootstrap_worker() {
  echo "Setting up k3s worker node"
  export K3S_NODE_NAME="$1"
  export K3S_KUBECONFIG_MODE="600"
  export K3S_URL="https://192.168.178.100:6443"
  export K3S_TOKEN="$2"

  if [ -z "$K3S_TOKEN" ]; then
    echo "K3S_TOKEN is required"
    exit 1
  fi
  export INSTALL_K3S_EXEC="agent --server $K3S_URL --token $K3S_TOKEN"

  curl -sfL https://get.k3s.io | sh -
}

function configure_kubeconfig() {
  # Sets up kubeconfig for installed k3s cluster
  mkdir ~/.kube 2> /dev/null

  # Requires zsh
  echo "export KUBECONFIG=$KUBECONFIG" >> ~/.zshrc
  source ~/.zshrc

  sudo k3s kubectl config view --raw > "$KUBECONFIG"
  chmod 600 "$KUBECONFIG"
}