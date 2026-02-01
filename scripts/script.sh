
#!/bin/bash
TOKEN="rtBN8ZSN314W699defkmj"
HOSTNAME=$(hostname)
# retrieve the  IP address of the host
IP_MASTER=$(hostname -I | awk '{print $2}')
echo " difine master node =========> ::  "  $IP_MASTER  
 
# reset   an  existing  cluster  
#kubeadm reset -f 
#sudo rm -rf /etc/cni/net.d
# Initialize the Kubernetes master node and create cluster
kubeadm init --apiserver-advertise-address=$IP_MASTER --token="$TOKEN" --pod-network-cidr=10.244.0.0/16
sudo mkdir -p $HOME/.kube
chmod  rwxr-xr-- /etc/kubernetes/admin.conf
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Needs manual creation of namespace to avoid Helm error
kubectl create ns kube-flannel
kubectl label --overwrite ns kube-flannel pod-security.kubernetes.io/enforce=privileged

helm repo add flannel https://flannel-io.github.io/flannel/
helm install flannel --set podCidr="10.244.0.0/16" --namespace kube-flannel flannel/flannel
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml


echo "restart  end  enable kubelet "
systemctl enable kubelet
service kubelet restart
echo  " End of  creation  of cluster   ========>  :  "$IP_MASTER















rm -rf $HOME/.kube
sudo rm -rf /etc/cni/net.d

sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd

sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
# Assurez-vous que SystemdCgroup est à true si nécessaire
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd

sudo systemctl stop kubelet
sudo ipvsadm --clear  # Si vous utilisiez IPVS
sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X









config.vm.provision "shell", path: "scripts/common-install.sh"  will  install   kubernetes tools (kubectl,kubeadm,kubelet,kubernates-cni).  config.vm.provision "shell", path: "scripts/cluster-install.sh" create  a  cluster   kubernetes  using  kubeadm  and  configure  CRI           .                               config.vm.provision "shell", path: "scripts/node-join.sh"   allow  worker node  to  join  cluster.  master-node ip :192.168.10.1  ,worker-node ip :192.168.10.2                          All  these script  will  be used in  Vagrantfile
