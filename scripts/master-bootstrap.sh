#!/usr/bin/env bash

set -euo pipefail

log() { echo "[master-bootstrap] $*"; }

REPO_URL="https://github.com/jkatindi/jobmatch.git"
CLONE_DIR="/home/vagrant/jobmatch"

# Ensure running as root for kubectl with admin.conf and package operations
if [[ $EUID -ne 0 ]]; then
  exec sudo -E bash "$0" "$@"
fi

log "Ensuring git is installed..."
if ! command -v git >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y git
fi

log "Preparing vagrant home permissions..."
id vagrant &>/dev/null || useradd -m -s /bin/bash vagrant || true
chown -R vagrant:vagrant /home/vagrant || true

if [[ ! -d "$CLONE_DIR/.git" ]]; then
  log "Cloning $REPO_URL into $CLONE_DIR ..."
  sudo -u vagrant git clone --depth 1 "$REPO_URL" "$CLONE_DIR"
else
  log "Repository already present, pulling latest..."
  pushd "$CLONE_DIR" >/dev/null
  sudo -u vagrant git pull --ff-only || true
  popd >/dev/null
fi

# Apply Kubernetes manifests if control plane is initialized
KUBECONFIG_PATH="/etc/kubernetes/admin.conf"
if [[ -f "$KUBECONFIG_PATH" ]]; then
  export KUBECONFIG="$KUBECONFIG_PATH"
  log "Kubernetes admin.conf found. Attempting to apply manifests..."

  # Determine manifest path preference
  MANIFEST="${CLONE_DIR}/deployment.yaml"
  if [[ -f "$MANIFEST" ]]; then
    log "Applying $MANIFEST"
    kubectl apply -f "$MANIFEST" || log "kubectl apply of deployment.yaml failed (will continue)."
  elif [[ -f "${CLONE_DIR}/k8s/kustomization.yaml" ]]; then
    log "Applying kustomization in k8s/"
    kubectl apply -k "${CLONE_DIR}/k8s" || log "kubectl apply -k k8s failed (will continue)."
  elif compgen -G "${CLONE_DIR}/k8s/*.yaml" > /dev/null; then
    log "Applying all YAMLs in k8s/ directory..."
    kubectl apply -f "${CLONE_DIR}/k8s" || log "kubectl apply -f k8s/ failed (will continue)."
  else
    log "No known manifest files found to apply."
  fi
else
  log "Control plane not initialized yet (missing admin.conf). Skipping kubectl apply for now."
  log "After running 'kubeadm init', re-run: sudo bash /vagrant/scripts/master-bootstrap.sh"
fi

log "Master bootstrap completed."
