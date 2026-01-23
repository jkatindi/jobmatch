#!/bin/bash

## install  common  for  k8s
HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $2}')
echo  "start  - install  common   - "$IP

echo " [1] : add  host name for  ip "
host_exist=$(cat /etc/hosts | grep  -i "$IP" |  wc  -l)
if ["$host_exist"=="0"]; then
 echo "$IP  $HOSTNAME " >/etc/hosts
fi

echo " [2] desable swap "
#swapoff -a to  desable swapping 
swapoff -a 
sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab

echo " [3] : install  utils "
apt-get update -qq >/dev/null
apt-get install -y  -qq apt-transport-https curl >/dev/null

echo " [4]: install  docker if not  exist "
if [ ! -f "/usr/bin/docker" ]; then
 curl -s -fsSL https://get.docker.com | sh
fi

 echo " [5] : add kubenates  repository to source.list"
 if [! -f "/etc/apt/sources.list.d/kubernetes.list" ]; then
   curl -s  https://packages.cloud.google.com/apt/doc/apt-key.gpg |  apt-key add -
   echo "deb http://apt.kubernetes.io/ kubernates-xenial main " >/etc/apt/sources.list.d/kubernetes.list
 fi
 
 echo " [6] : install  kubelet / kubeadm / kubectl / kubernetes-cni "
 apt-get install  -y -qq  kubelet kubeadm kubectl kubernetes-cni >/dev/null
 echo "END -Install  common  -" 