#!/bin/bash

set -euo pipefail

TOKEN="m3v8j9.q1w2e3r4t5y6u7i8"
HOSTNAME=$(hostname)
POD_CIDR="10.244.0.0/16" # Flannel default
MASTER_IP=$(hostname | awk '{print $2}')
echo "[cluster-install] Master node hostname: $HOSTNAME, IP: $MASTER_IP"

echo "[cluster-install] Configure containerd (SystemdCgroup=true)"

sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

if [ -f /etc/kubernetes/admin.conf ]; then
  echo "[cluster-install] Cluster appears initialized already. Skipping kubeadm init."
else
  echo "[cluster-install] Initializing control plane with kubeadm..."
  sudo kubeadm init  --apiserver-advertise-address=$MASTER_IP  --ignore-preflight-errors=all --pod-network-cidr=$POD_CIDR --token="$TOKEN"
fi

echo "[cluster-install] Setting kubeconfig for current user"
mkdir -p "$HOME/.kube"
sudo cp -i /etc/kubernetes/admin.conf "$HOME/.kube/config"
sudo chown $(id -u):$(id -g) "$HOME/.kube/config"

echo "[cluster-install] Installing Flannel CNI"
kubectl create ns kube-flannel --dry-run=client -o yaml | kubectl apply -f - || true
kubectl label --overwrite ns kube-flannel pod-security.kubernetes.io/enforce=privileged || true
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

echo "[cluster-install] Restarting kubelet"
sudo systemctl restart kubelet || true
echo "[cluster-install] Control plane ready on ${MASTER_IP}"


















