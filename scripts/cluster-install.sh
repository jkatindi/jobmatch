#!/bin/bash

HOSTNAME=$(hostname)
# retrieve the  IP address of the host
IP_MASTER=$(hostname -I | awk '{print $2}')

# Initialize the Kubernetes master node and create cluster
sudo kubeadm init --apiserver-advertise-address=$IP_MASTER --pod-network-cidr=10.244.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# Generate the join command and save it to a file for worker nodes
kubeadm token create --print-join-command > /vagrant/join-command.sh
chmod +x /vagrant/join-command.sh
if [ ! -d "/home/vagrant/jkatindi/.git"]; then
    echo "creating jobmatch directory"
    sudo mkdir -p /home/vagrant/jkatindi
    git clone https://github.com/jkatindi/jobmatch.git /home/vagrant/jkatindi
    kubectl apply -f /home/vagrant/jkatindi/jobmatch/k8s/kustomization.yaml
    e
fi