#!/bin/bash

set -euo pipefail

HOSTNAME=$(hostname)
MASTER_IP="192.168.10.2"
TOKEN="m3v8j9.q1w2e3r4t5y6u7i8"
echo "[node-join] Worker hostname: $HOSTNAME"

echo "[node-join] Configure containerd (SystemdCgroup=true)"
udo rm /etc/containerd/config.toml
sudo systemctl restart containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
sudo systemctl restart containerd
echo "[node-join] Reset any previous kubeadm state"
sudo kubeadm reset -f || true

echo "[node-join] Enable kubelet service"
sudo systemctl enable kubelet || true

kubeadm  join --ignore-preflight-errors=all  --token="$TOKEN"  $MASTER_IP:6443 --discovery-token-unsafe-skip-ca-verification

echo "[node-join] Restarting kubelet"
sudo systemctl restart kubelet || true
echo "[node-join] Done"