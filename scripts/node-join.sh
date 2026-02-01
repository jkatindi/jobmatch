#!/bin/bash

set -euo pipefail

HOSTNAME=$(hostname)
MASTER_IP="192.168.10.2"
JOIN_FILE="/vagrant/join.sh"

echo "[node-join] Worker hostname: $HOSTNAME"

echo "[node-join] Configure containerd (SystemdCgroup=true)"
sudo mkdir -p /etc/containerd
if [ ! -f /etc/containerd/config.toml ]; then
  containerd config default | sudo tee /etc/containerd/config.toml >/dev/null
fi
sudo sed -i 's/^\(\s*SystemdCgroup = \)false/\1true/' /etc/containerd/config.toml || true
sudo systemctl enable --now containerd

echo "[node-join] Reset any previous kubeadm state"
sudo kubeadm reset -f || true

echo "[node-join] Enable kubelet service"
sudo systemctl enable kubelet || true

echo "[node-join] Waiting for join command at $JOIN_FILE from master ($MASTER_IP) ..."
for i in {1..120}; do
  if [ -s "$JOIN_FILE" ]; then
    echo "[node-join] Found join script. Executing..."
    sudo bash "$JOIN_FILE"
    JOIN_RC=$?
    if [ $JOIN_RC -eq 0 ]; then
      echo "[node-join] Successfully joined the cluster at $MASTER_IP"
      break
    else
      echo "[node-join] Join failed with code $JOIN_RC, retrying in 5s..."
      sleep 5
    fi
  else
    sleep 1
  fi
done

echo "[node-join] Restarting kubelet"
sudo systemctl restart kubelet || true
echo "[node-join] Done"