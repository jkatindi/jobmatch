Vagrant.configure("2") do |config|
  # Base box for all nodes
  config.vm.box = "ubuntu/jammy64"

  # Disable default synced folder for performance and to keep repo clean inside VMs
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # Default provider settings for all machines
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
    vb.cpus = 2
  end

  # Kubernetes master node
  config.vm.define "node-master" do |node|
    node.vm.hostname = "node-master"
    node.vm.network "private_network", ip: "192.168.0.45"
    node.vm.provider "virtualbox" do |vb|
      vb.name = "node-master"
    end
    # Install K8s dependencies/tools
    node.vm.provision "shell", path: "install-dependencies.sh"
    # Clone repo and (if cluster initialized) apply manifests
    node.vm.provision "shell", path: "scripts/master-bootstrap.sh"
  end

  # Kubernetes worker node 1
  config.vm.define "node-worker1" do |node|
    node.vm.hostname = "node-worker1"
    node.vm.network "private_network", ip: "192.168.0.37"
    node.vm.provider "virtualbox" do |vb|
      vb.name = "node-worker1"
    end
    node.vm.provision "shell", path: "install-dependencies.sh"
  end

  # Kubernetes worker node 2
  config.vm.define "node-worker2" do |node|
    node.vm.hostname = "node-worker2"
    node.vm.network "private_network", ip: "192.168.0.40"
    node.vm.provider "virtualbox" do |vb|
      vb.name = "node-worker2"
    end
    node.vm.provision "shell", path: "install-dependencies.sh"
  end

  config.vm.provision "shell", inline: <<-SHELL
    sed -i 's/ChallengeResponseAuthentification no/ChallengeResponseAuthentification yes/g' /etc/ssh/sshd_config
    service ssh restart
  SHELL

  # Notes:
  # - The specified private IPs are configured on a host-only network managed by VirtualBox.
  #   Ensure they do not conflict with your LAN. If VirtualBox cannot create a host-only adapter
  #   on 192.168.0.0/24 due to conflicts, consider adjusting your host networking or VirtualBox settings.
  # - After machines are up, initialize the control plane on node-master with kubeadm,
  #   then join workers. Re-run master bootstrap to apply manifests if needed.
end
