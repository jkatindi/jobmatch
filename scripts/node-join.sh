#!/bin/bash

set -euo pipefail

HOSTNAME=$(hostname)
MASTER_IP="192.168.10.2"
#TOKEN="m3v8j9.q1w2e3r4t5y6u7i8"
echo "[node-join] Worker hostname: $HOSTNAME"

sudo systemctl enable kubelet

#kubeadm  join --ignore-preflight-errors=all  --token="$TOKEN"  $MASTER_IP:6443 --discovery-token-unsafe-skip-ca-verification
while [ ! -f /root/vagrant/join.sh]; do
sleep 5
done
chmod +x /root/vagrant/join.sh

echo "[node-join] Restarting kubelet"
sudo systemctl restart kubelet 
echo "[node-join] Done"