Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.box_version = "20241002.0.0"
  config.vm.synced_folder ".", "/vagrant", disabled: false
  
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
    vb.cpus = 2
  end

  # Kubernetes master node
  config.vm.define "node-master" do |node|
    node.vm.hostname = "node-master"
    node.vm.network "private_network", ip: "192.168.10.40"
    node.vm.provider "virtualbox" do |vb|
      vb.name = "node-master"
    end
    # Activer l'authentification par mot de passe pour sshpass
    node.vm.provision "shell", inline: <<-SHELL
      sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
      systemctl restart sshd
    SHELL
    node.vm.provision "shell", path: "scripts/common-install.sh"
    node.vm.provision "shell", path: "scripts/cluster-install.sh"
  end

  # Kubernetes workers nodes 
  numberServ = 3
  (1..numberServ).each do |i|
    config.vm.define "node-worker#{i}" do |node|
      node.vm.hostname = "node-worker#{i}"
      node.vm.network "private_network", ip: "192.168.10.4#{i}"
      node.vm.provider "virtualbox" do |vb|
        vb.name = "node-worker#{i}"
      end
      # Activer l'authentification par mot de passe pour sshpass
      node.vm.provision "shell", inline: <<-SHELL
        sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
        systemctl restart sshd
        apt-get update && apt-get install -y sshpass
      SHELL
      node.vm.provision "shell", path: "scripts/common-install.sh"
      # EXECUTION EN TANT QU'UTILISATEUR VAGRANT (privileged: false)
      node.vm.provision "shell", path: "scripts/node-join.sh", privileged: false
    end
  end 
  config.vm.provision "shell", path: "scripts/deploiment.sh", privileged: false
end
