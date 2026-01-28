#!/bin/bash
TOKEN="rtBN8ZSN314W699defkmj"
HOSTNAME=$(hostname)
# retrieve the  IP address of the host
IP_ADR=$(hostname -I | awk '{print $2}')
echo " difine master node =========> ::  "  $IP_ADR 
 
# reset   an  existing  cluster  
kubeadm reset -f 

# worker nodes join  cluster
echo "join  this worker node $IP_ADR  to  cluster "
kubeadm join  192.168.10.2:6443   --ignore-preflight-errors=all  --token="$TOKEN"  

echo "restart  end  enable kubelet "
systemctl enable kubelet
service kubelet restart
echo  " End of  creation  of cluster   ========>  :  "$IP_ADR