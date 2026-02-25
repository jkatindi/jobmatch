#!/bin/bash
set -euo pipefail

MASTER_IP=192.168.10.100
HOST_IP=$(hostname -I | awk '{print $2}')
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
# generate the  ssh key Ed25519 for the vagrant user if it does not exist, to allow passwordless scp in future runs	
# generate the  ssh key Ed25519 for the vagrant user if it does not exist, to allow passwordless scp in future runs
# Générer la clé du worker
if [ ! -f /home/vagrant/.ssh/id_ed25519 ]; then
    sudo -u vagrant ssh-keygen -t ed25519 -f /home/vagrant/.ssh/id_ed25519 -N "" -q
fi
sudo -u vagrant sshpass -p 'vagrant' ssh-copy-id -o StrictHostKeyChecking=no vagrant@${MASTER_IP}
JOIN_SRC="/home/vagrant/configs/kubeadm_join_cmd.sh"
sshpass -p 'vagrant' scp -o StrictHostKeyChecking=no -o  vagrant@${MASTER_IP}:${JOIN_SRC} /home/scripts/
sudo -u vagrant scp vagrant@${MASTER_IP}:${JOIN_SRC} /home/scripts

if [ ! -f /home/scripts/kubeadm_join_cmd.sh ]; then
	echo "Could not fetch join command from ${MASTER_IP}:${JOIN_SRC}."
	echo "Please copy the file /home/vagrant/configs/kubeadm_join_cmd.sh from the master to /home/scripts on this node and re-run."
	exit 1
fi


echo "[worker-setup] Executing join command..."
sudo sh /home/scripts/kubeadm_join_cmd.sh --v=5
sudo systemctl restart kubelet