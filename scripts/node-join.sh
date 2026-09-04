#!/bin/bash


echo "Script de jointure au cluster Kubernetes [1]"
# Configuration des variables pour l'utilisateur vagrant
USER_HOME="/home/vagrant"
echo "Répertoire de l'utilisateur vagrant : $USER_HOME [2]"
# Générer une clé SSH pour l'utilisateur vagrant si elle n'existe pas déjà
if [ ! -f "$USER_HOME/.ssh/id_rsa" ]; then
    echo "Clé SSH non trouvée. Génération d'une nouvelle clé SSH pour l'utilisateur vagrant..."
    sudo -u vagrant ssh-keygen -t rsa -b 2048 -f "$USER_HOME/.ssh/id_rsa" -N ""
else
    echo "Clé SSH existante trouvée pour l'utilisateur vagrant."
fi


# installer sshpass si ce n'est pas déjà fait
if ! command -v sshpass &> /dev/null; then
    echo "sshpass n'est pas installé. Installation en cours..."
    sudo apt-get update
    sudo apt-get install -y sshpass
fi
# Envoyer la clé publique au Master (IP: 192.168.10.40)
export SSHPASS=vagrant
sudo -u vagrant -E sshpass -e ssh-copy-id -o StrictHostKeyChecking=no vagrant@192.168.10.40

echo "Récupération du script de jointure depuis le Master [3]"
mkdir -p /home/vagrant/scripts
sudo -u vagrant scp -o StrictHostKeyChecking=no vagrant@192.168.10.40:/home/vagrant/scripts/join_command.sh /home/vagrant/scripts/

# changer le propriétaire du script de jointure pour l'utilisateur vagrant
sudo chown vagrant:vagrant /home/vagrant/scripts/join_command.sh
# changer les permissions pour que le script soit exécutable
sudo bash /home/vagrant/scripts/join_command.sh
echo "Script de jointure terminé. Le nœud a été ajouté au cluster Kubernetes."

