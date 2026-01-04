#!/usr/bin/env bash

set -euo pipefail

log() { echo "[install-dependencies] $*"; }

require_root() {
  if [[ "${EUID}" -ne 0 ]]; then
    log "This script must be run as root; re-executing with sudo..."
    exec sudo -E bash "$0" "$@"
  fi
}

require_root "$@"

export DEBIAN_FRONTEND=noninteractive

log "Updating apt index..."
apt-get update -y

log "Installing base packages..."
apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release software-properties-common jq

# Disable swap (required by Kubernetes)
if swapon --summary | grep -q .; then
  log "Disabling swap..."
  swapoff -a || true
fi
sed -i.bak '/\sswap\s/s/^/#/' /etc/fstab || true

# Kernel modules and sysctl settings
log "Configuring kernel modules and sysctl for Kubernetes networking..."
cat >/etc/modules-load.d/containerd.conf <<'MODULES'
overlay
br_netfilter
MODULES

modprobe overlay || true
modprobe br_netfilter || true

cat >/etc/sysctl.d/99-kubernetes-cri.conf <<'SYSCTL'
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
SYSCTL

sysctl --system >/dev/null

# Install containerd
if ! command -v containerd >/dev/null 2>&1; then
  log "Installing containerd runtime..."
  apt-get install -y containerd
fi

log "Configuring containerd to use systemd cgroup..."
mkdir -p /etc/containerd
containerd config default >/etc/containerd/config.toml 2>/dev/null || true
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml || true
systemctl enable containerd
systemctl restart containerd

# Install Kubernetes components (kubeadm, kubelet, kubectl)
if ! command -v kubeadm >/dev/null 2>&1; then
  log "Adding Kubernetes APT repository..."
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  chmod 0644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" \
    >/etc/apt/sources.list.d/kubernetes.list

  log "Installing kubelet, kubeadm, kubectl..."
  apt-get update -y
  apt-get install -y kubelet kubeadm kubectl
  apt-mark hold kubelet kubeadm kubectl
else
  log "Kubernetes tools already installed; ensuring they are held..."
  apt-mark hold kubelet kubeadm kubectl || true
fi

log "Ensuring kubelet is enabled but not started (will start after kubeadm init/join)..."
systemctl enable kubelet || true
systemctl stop kubelet || true

log "All dependencies installed and configured."
