#!/bin/bash

set -euo pipefail

TOKEN="rpjvog.69g8skutr5se7hnj"
HOSTNAME=$(hostname)
#POD_CIDR="10.244.0.0/16" # Flannel default
POD_CIDR="192.168.0.0/16" # Calico
MASTER_IP=$(hostname | awk '{print $2}')

echo "before  installing cluster, reset  all  nodes and config  with  kubeadm reset -f"
sudo rm -rf /etc/kubernetes/
sudo rm -rf /var/lib/kubelet/
sudo rm -rf /var/lib/etcd/

sudo apt update && sudo apt install conntrack -y
sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X

echo "[cluster-install] Master node hostname: $HOSTNAME, IP: $MASTER_IP"

echo "[cluster-install] Configure containerd (SystemdCgroup=true)"

sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd
sudo mkdir -p /etc/containerd

if [ ! -f "/etc/containerd/config.toml" ] ; then
  containerd config default | sudo tee /etc/containerd/config.toml >/dev/null
  sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
  sudo sed -i 's|sandbox_image = .*|sandbox_image = "registry.k8s.io/pause:3.10"|' /etc/containerd/config.toml
  sudo systemctl restart containerd
fi  

if [ -f  "/etc/kubernetes/admin.conf" ]; then
  echo "[cluster-install] Cluster appears initialized already. Skipping kubeadm init."
else
  echo "[cluster-install] Initializing control plane with kubeadm..."

  sudo kubeadm init  --ignore-preflight-errors=all \
  --apiserver-advertise-address=192.168.10.100 \
  --token="ob2q43.y9y61hnyt7g11okl" \
  --pod-network-cidr=$POD_CIDR 
   #   find /etc  -type f  -exec  sudo   sed -i 's/10.0.2.15/192.168.10.100/g' {} +
 
echo "[cluster-install] Setting kubeconfig for current user"
sudo systemctl stop kubelet
# Si le port est encore actif, tuez le processus manuellement
sudo fuser -k 10250/tcp
sudo systemctl restart kubelet
sudo mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


# creation join  file command  to  store in  /root/vagr
fi

echo "[cluster-install] Installing Calico CNI"
kubectl create -f https://docs.projectcalico.org/manifests/calico.yaml  
 

kubeadm token create --print-join-command >> /etc/kubeadm_join_cmd.sh
sudo chmod 644 /etc/kubeadm_join_cmd.sh
echo "[cluster-install] Control plane ready on " $MASTER_IP
echo "[cluster-install] Restarting kubelet"
sudo systemctl restart kubelet















