#!/bin/bash

TOKEN="rtBN8ZSN314W699defkmj"
HOSTNAME=$(hostname)
# retrieve the  IP address of the host
IP_MASTER=$(hostname -I | awk '{print $2}')
echo " difine master node =========> ::  "  $IP_MASTER  
 
# reset   an  existing  cluster  
#kubeadm reset -f 

# Initialize the Kubernetes master node and create cluster
kubeadm init --apiserver-advertise-address=$IP_MASTER --token="$TOKEN" --pod-network-cidr=192.168.0.0/16
mkdir -p $HOME/.kube
sudo scp -i $IP_MASTER:/etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
#kubectl apply -f https://https://docs.projectcalico.org/v3.11/manifests/calico.yml
kubectl create -f https://docs.projectcalico.org/manifests/calico.yaml

echo "restart  end  enable kubelet "
systemctl enable kubelet
service kubelet restart
echo  " End of  creation  of cluster   ========>  :  "$IP_MASTER



















