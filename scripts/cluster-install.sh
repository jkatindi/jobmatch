#!/bin/bash

# initialiser le cluster
sudo kubeadm reset -f
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

# Initialisation du Master
sudo kubeadm init --apiserver-advertise-address=192.168.10.40  --pod-network-cidr=10.244.0.0/16
USER_HOME=$(eval echo "~${SUDO_USER:-$USER}")
sudo cp -i /etc/kubernetes/admin.conf $USER_HOME/.kube/config
sudo chown $(id -u ${SUDO_USER:-$USER}):$(id -g ${SUDO_USER:-$USER}) $USER_HOME/.kube/config
# Configurer kubectl pour l'utilisateur 
# Configuration définitive de kubectl pour l'utilisateur vagrant
export KUBECONFIG=$USER_HOME/.kube/config
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

mkdir -p /home/vagrant/scripts

# Générer la commande join avec des permissions de lecture pour SCP
kubeadm token create --print-join-command | sudo tee /home/vagrant/scripts/join_command.sh
chmod 744 /home/vagrant/scripts/join_command.sh

# --- CORRECTION SSH ---
# Autoriser temporairement l'authentification par mot de passe pour ssh-copy-id
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
# modifier la directive KbdInteractiveAuthentication pour permettre l'authentification par mot de passe
sudo sed -i 's/KbdInteractiveAuthentication no/KbdInteractiveAuthentication yes/g' /etc/ssh/sshd_config
find /etc/ssh/sshd_config.d/ -type f -exec sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' {} + 2>/dev/null
sudo systemctl restart sshd

# configurer kubectl pour l'ulisateur root
mkdir -p /root/.kube
sudo cp -i /etc/kubernetes/admin.conf /root/.kube/config
sudo chown -R root:root /root/.kube
echo " fin de initialisation du master node"
