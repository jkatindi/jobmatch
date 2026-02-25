#!/bin/bash

set -euo pipefail
sudo apt-get update && sudo apt-get install -y conntrack

TOKEN="rpjvog.69g8skutr5se7hnj"
HOSTNAME=$(hostname)
#POD_CIDR="10.244.0.0/16" # Flannel default
POD_CIDR="192.168.0.0/16" # Calico

# Detect primary IPv4 address more reliably, fallback to hostname -I
MASTER_IP=$(hostname -I | awk '{print $2}' || true)
echo "before installing cluster, reset all nodes and config with kubeadm reset -f"
echo "[cluster-install] Master node hostname: $HOSTNAME, IP: $MASTER_IP"
sudo kubeadm reset -f || true
sudo rm -rf /etc/kubernetes/ /var/lib/etcd /var/lib/kubelet /var/lib/dockershim ~/.kube/ || true
sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X || true
echo "[cluster-install] Configure containerd (SystemdCgroup=true)"
sudo systemctl stop kubelet || true
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml || true
sudo sed -i 's|sandbox_image = .*|sandbox_image = "registry.k8s.io/pause:3.10"|' /etc/containerd/config.toml || true
sudo systemctl restart containerd

echo "[cluster-install] Initializing control plane with kubeadm..."
sudo kubeadm init --ignore-preflight-errors=all --apiserver-advertise-address=$MASTER_IP --pod-network-cidr=$POD_CIDR

echo "[cluster-install] Setting kubeconfig for current user"
# If the script was run via sudo, prefer the original user; otherwise use current user
USER_HOME=$(eval echo "~${SUDO_USER:-$USER}")
sudo fuser -k 10250/tcp || true
sudo mkdir -p "$USER_HOME/.kube"
sudo cp -i /etc/kubernetes/admin.conf "$USER_HOME/.kube/config"
sudo chown $(id -u ${SUDO_USER:-$USER}):$(id -g ${SUDO_USER:-$USER}) "$USER_HOME/.kube/config"

echo "[cluster-install] Installing Calico CNI"
export KUBECONFIG="$USER_HOME/.kube/config"
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
sleep 5

# Write join command to a place worker scripts will expect (/home/vagrant/configs) if vagrant user exists,
# otherwise write to the invoking user's home under configs.
if id -u vagrant >/dev/null 2>&1; then
  JOIN_DIR=/home/vagrant/configs
else
  JOIN_DIR="$USER_HOME/configs"
fi
# autoriser  l'acces distant  ssh 
#autoriser  le  port  22  pour  les  connexions  ssh
sudo ufw allow 22/tcp || true
#autoriser  le  port  6443  pour  les  connexions  au  serveur  API  Kubernetes
sudo ufw allow 6443/tcp || true
# required  for setting up passwordless ssh between master and worker nodes, so that worker nodes can run the join command without manual intervention
sudo  sed -i 's/.*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config || true
sudo systemctl restart sshd || true

sudo mkdir -p "$JOIN_DIR"
sudo kubeadm token create --print-join-command > "$JOIN_DIR/kubeadm_join_cmd.sh"
sudo chmod +x "$JOIN_DIR/kubeadm_join_cmd.sh"
sudo chown -R ${SUDO_USER:-$USER}:${SUDO_USER:-$USER} "$JOIN_DIR" || true

if id -u vagrant >/dev/null 2>&1; then
  echo "vagrant:vagrant" | sudo chpasswd || true
fi
# generate ssh keys Ed25519 for passwordless ssh between master and worker nodes
if [ ! -f /home/vagrant/.ssh/id_ed25519 ]; then
  sudo -u vagrant ssh-keygen -t ed25519 -f /home/vagrant/.ssh/id_ed25519 -N "" || true
fi

echo "[cluster-install] Control plane ready on $MASTER_IP"
sudo systemctl restart kubelet || true


