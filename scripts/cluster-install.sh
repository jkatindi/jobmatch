#!/bin/bash

set -euo pipefail

TOKEN="m3v8j9.q1w2e3r4t5y6u7i8"
HOSTNAME=$(hostname)
#POD_CIDR="10.244.0.0/16" # Flannel default
POD_CIDR="192.168.0.0/16" # Calico
MASTER_IP=$(hostname | awk '{print $2}')
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
  sudo kubeadm reset -f
  sudo kubeadm init --ignore-preflight-errors=all  --apiserver-advertise-address=$MASTER_IP  --pod-network-cidr=$POD_CIDR   
  
fi

echo "[cluster-install] Setting kubeconfig for current user"
sudo mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "[cluster-install] Installing Calico CNI"
kubectl create -f https://docs.projectcalico.org/manifests/calico.yaml
# creation join  file command  to  store in  /root/vagrant/
sudo mkdir  -p  /root/vagrant
sudo kubeadm token create --print-join-command |  tee /root/vagrant/join.sh
sudo  sed -i  's/10.0.2.15/'"$MASTER_IP"'/g' /root/vagrant/join.sh   
chmod +x /root/vagrant/join.sh
cat  /root/vagrant/join.sh

echo "[cluster-install] Restarting kubelet"
sudo systemctl restart kubelet 
echo "[cluster-install] Control plane ready on " $MASTER_IP

















