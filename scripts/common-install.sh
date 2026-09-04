#!/bin/bash

## install common for k8s
HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $2}') # Changed to $1 to ensure a valid IP is captured
echo "start - install common - $IP"

echo " [1] : add host name for ip "
# Added required spaces inside the [ ] brackets
# host_exist=$(cat /etc/hosts | grep  -i "$IP" |  wc  -l)
# echo $(hostname -I | awk '{print $1}')
if [ "$(grep -c "$IP" /etc/hosts)" -eq 0 ]; then
  echo "$IP $HOSTNAME" >> /etc/hosts
fi

echo " [2] disable swap "
swapoff -a
sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab


# configuration resau overlay
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter


# configuration Sysctl requise
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

echo " [3] : install utils "
apt-get update -qq
apt-get install -y -qq apt-transport-https ca-certificates curl gnupg >/dev/null
# ajouter le paquet conntrack 
apt-get install -y -qq conntrack >/dev/null 


echo " [4]: install docker/containerd if not exist "
sudo apt-get install -y -qq containerd >/dev/null
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml >/dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd
#if [ ! -f "/usr/bin/docker" ]; then
 # curl -fsSL https://get.docker.com | sh
#fi
usermod -aG docker vagrant
echo "vagrant:vagrant" | sudo chpasswd

echo " [5] : add kubernetes repository to source.list"
# Ensure directory exists and clean old files
sudo mkdir -p -m 755 /etc/apt/keyrings
sudo rm -f /etc/apt/sources.list.d/kubernetes.list
sudo rm -f /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Download key and add the CORRECT repository path for v1.31
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo " [6] : install kubelet / kubeadm / kubectl "
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl  kubernetes-cni >/dev/null
sudo apt-mark hold kubelet kubeadm kubectl
echo "****************   END - Install common dependencies -   ****************** $IP"