#!/bin/bash
TOKEN="rtBN8ZSN314W699defkmj"
HOSTNAME=$(hostname)
IP_MASTER=192.168.10.2
# retrieve the  IP address of the host
IP_ADR=$(hostname -I | awk '{print $2}')
echo " difine work node =========> ::  "  $IP_ADR 
 
# reset   an  existing  cluster  
kubeadm reset -f 

# worker nodes join  cluster
echo "join  this worker node $IP_ADR  to  cluster  lead  by => "$IP_MASTER
kubeadm join --ignore-preflight-errors=all   --token=$TOKEN  $IP_MASTER:6443  --discovery-token-unsafe-skip-ca-verification
 
echo "restart  end  enable kubelet "
systemctl enable kubelet
service kubelet restart
echo  " End of  creation  of cluster   ========>  :  "$IP_ADR