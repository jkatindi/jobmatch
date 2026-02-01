#!/bin/bash

set -euo pipefail

TOKEN="rtBN8ZSN314W699defkmj"
HOSTNAME=$(hostname)
POD_CIDR="10.244.0.0/16" # Flannel default
MASTER_IP=$(hostname | awk '{print $2}')
echo "[cluster-install] Master node hostname: $HOSTNAME, IP: $MASTER_IP"

echo "[cluster-install] Configure containerd (SystemdCgroup=true)"
sudo mkdir -p /etc/containerd
if [ ! -f /etc/containerd/config.toml ]; then
  containerd config default | sudo tee /etc/containerd/config.toml >/dev/null
fi
sudo sed -i 's/^\(\s*SystemdCgroup = \)false/\1true/' /etc/containerd/config.toml || true
sudo systemctl enable --now containerd

echo "[cluster-install] Enable kubelet service"
sudo systemctl enable kubelet || true

if [ -f /etc/kubernetes/admin.conf ]; then
  echo "[cluster-install] Cluster appears initialized already. Skipping kubeadm init."
else
  echo "[cluster-install] Initializing control plane with kubeadm..."
  sudo kubeadm init \
    --apiserver-advertise-address=${MASTER_IP} \
    --pod-network-cidr=${POD_CIDR} \
    --token="${TOKEN}"
fi

echo "[cluster-install] Setting kubeconfig for current user"
mkdir -p "$HOME/.kube"
sudo cp -i /etc/kubernetes/admin.conf "$HOME/.kube/config"
sudo chown $(id -u):$(id -g) "$HOME/.kube/config"

echo "[cluster-install] Installing Flannel CNI"
kubectl create ns kube-flannel --dry-run=client -o yaml | kubectl apply -f - || true
kubectl label --overwrite ns kube-flannel pod-security.kubernetes.io/enforce=privileged || true
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

echo "[cluster-install] Generating join command and saving to /vagrant/join.sh"
JOIN_FILE="/vagrant/join.sh"
sudo kubeadm token create --print-join-command > "$JOIN_FILE" || {
  echo "kubeadm token create failed, attempting to re-use existing token..."
  sudo kubeadm token list >/dev/null
  sudo kubeadm token create --print-join-command > "$JOIN_FILE"
}
echo "sudo " | cat - "$JOIN_FILE" > "${JOIN_FILE}.tmp" && mv "${JOIN_FILE}.tmp" "$JOIN_FILE"
chmod +x "$JOIN_FILE"

echo "[cluster-install] Restarting kubelet"
sudo systemctl restart kubelet || true
echo "[cluster-install] Control plane ready on ${MASTER_IP}"



















