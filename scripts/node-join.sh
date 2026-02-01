#!/bin/bash

set -euo pipefail

HOSTNAME=$(hostname)
MASTER_IP="192.168.10.2"
TOKEN="4GG5YUmpDFk9vY8rZT7mj"
echo "[node-join] Worker hostname: $HOSTNAME"

echo "[node-join] Configure containerd (SystemdCgroup=true)"
sudo mkdir -p /etc/containerd
if [ ! -f /etc/containerd/config.toml ]; then
  containerd config default | sudo tee /etc/containerd/config.toml >/dev/null
fi
#sudo sed -i 's/^\(\s*SystemdCgroup = \)false/\1true/' /etc/containerd/config.toml || true
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

sudo systemctl enable --now containerd

echo "[node-join] Reset any previous kubeadm state"
sudo kubeadm reset -f || true

echo "[node-join] Enable kubelet service"
sudo systemctl enable kubelet || true

kubeadm  join --ignore-preflight-errors=all  --token="$TOKEN"  $MASTER_IP:6443 \
  --discovery-token-unsafe-skip-ca-verification

echo "[node-join] Restarting kubelet"
sudo systemctl restart kubelet || true
echo "[node-join] Done"