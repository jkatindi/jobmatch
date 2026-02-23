#!/bin/bash
set -euo pipefail

MASTER_IP=${1:-}
if [ -z "$MASTER_IP" ]; then
	# Try to find default gateway IP as master if not provided
	MASTER_IP=$(ip -4 route show default 2>/dev/null | awk '/default/ {print $3; exit}')
fi
HOST_IP=$(hostname -I | awk '{print $1}')
HOSTNAME=$(hostname)
echo "[worker-setup] Hostname: $HOSTNAME, Host IP: $HOST_IP, Master IP: $MASTER_IP"

echo "[worker-setup] Cleanup..."
sudo kubeadm reset -f || true
sudo rm -rf /etc/kubernetes/ /var/lib/etcd /var/lib/kubelet /var/lib/dockershim ~/.kube/ || true
sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X || true

echo "[worker-setup] Configure containerd (SystemdCgroup=true)"
sudo systemctl stop kubelet || true
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml || true
sudo sed -i 's|sandbox_image = .*|sandbox_image = "registry.k8s.io/pause:3.10"|' /etc/containerd/config.toml || true
sudo systemctl restart containerd

echo "[worker-setup] Waiting for master join command to become available..."
sudo mkdir -p /home/scripts

# Prefer scp with sshpass if available, otherwise try scp with keyless or manual copy.
JOIN_SRC="/home/vagrant/configs/kubeadm_join_cmd.sh"
if command -v sshpass >/dev/null 2>&1; then
	sshpass -p 'vagrant' scp -o StrictHostKeyChecking=no vagrant@${MASTER_IP}:${JOIN_SRC} /home/scripts/
else
	# Try scp without password (assumes shared filesystem or keys), fall back to curl from master if HTTP served
	scp -o StrictHostKeyChecking=no vagrant@${MASTER_IP}:${JOIN_SRC} /home/scripts/ || true
fi

if [ ! -f /home/scripts/kubeadm_join_cmd.sh ]; then
	echo "Could not fetch join command from ${MASTER_IP}:${JOIN_SRC}."
	echo "Please copy the file /home/vagrant/configs/kubeadm_join_cmd.sh from the master to /home/scripts on this node and re-run."
	exit 1
fi

echo "[worker-setup] Executing join command..."
sudo sh /home/scripts/kubeadm_join_cmd.sh --v=5
