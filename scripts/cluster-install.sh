#!/bin/bash
TOKEN="rtBN8ZSN314W699defkmj"
HOSTNAME=$(hostname)
# retrieve the  IP address of the host
IP_MASTER=$(hostname -I | awk '{print $2}')
echo " difine master node =========> ::  "  $IP_MASTER  
 
# reset   an  existing  cluster  
kubeadm reset -f 

# Initialize the Kubernetes master node and create cluster
kubeadm init --apiserver-advertise-address=$IP_MASTER --token="$TOKEN" --pod-network-cidr=10.244.0.0/16
sudo mkdir -p $HOME/.kube
chmod  rwxr-xr-- /etc/kubernetes/admin.conf
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

if [ ! -d "/home/vagrant/jobmatch/.git"]; then
    echo "creating jobmatch directory"
    mkdir -p /home/vagrant/jobmatch
    git clone https://github.com/jkatindi/jobmatch.git /home/vagrant/jobmatch
    kubectl apply -f /home/vagrant/jkatindi/jobmatch/k8s/kustomization.yaml
    
fi

echo "restart  end  enable kubelet "
systemctl enable kubelet
service kubelet restart
echo  " End of  creation  of cluster   ========>  :  "$IP_MASTER