#!/bin/bash
set -euo pipefail

echo "[worker-setup] Installation de sshpass..."
sudo apt-get update && sudo apt-get install -y sshpass

echo "[worker-setup] Récupération de la commande join..."
# On télécharge dans /tmp pour éviter les problèmes de permissions
sshpass -p "vagrant" scp -o StrictHostKeyChecking=no vagrant@192.168.10.100:/etc/kubeadm_join_cmd.sh /tmp/kubeadm_join_cmd.sh

echo "[worker-setup] Exécution du join..."
sudo sh /tmp/kubeadm_join_cmd.sh
