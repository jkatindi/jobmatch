#!/bin/bash

set -euo pipefail
HOSTNAME=$(hostname)
NODE_IP=$(hostname | awk '{print $2}')
echo  "---------------->  change  default ip  to   " $NODE_IP
sudo rm -f /etc/default/kubelet
echo "KUBELET_EXTRA_ARGS=--node-ip=192.168.10.2" >  /etc/default/kubelet
systemctl restart kubelet
