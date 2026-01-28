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

echo " [3] : install utils "
apt-get update -qq
apt-get install -y -qq apt-transport-https ca-certificates curl gnupg >/dev/null

echo " [4]: install docker/containerd if not exist "
if [ ! -f "/usr/bin/docker" ]; then
  curl -fsSL https://get.docker.com | sh
fi

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
sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni >/dev/null
sudo apt-mark hold kubelet kubeadm kubectl
echo "****************   END - Install common dependencies -   ****************** $IP"
