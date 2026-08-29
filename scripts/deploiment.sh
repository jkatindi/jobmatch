#!/bin/bash

# 1. Vérification rapide de l'état des pods système
if ! kubectl get pods -n kube-system | grep -q "Running"; then
  echo " Le cluster Kubernetes n'est pas fonctionnel. Déploiement annulé."
  exit 1
fi

echo "✅ Le cluster est fonctionnel. Début du déploiement..."

# 2. Déploiement groupé (tous les fichiers en une seule commande)
kubectl apply -f ks8/mysql-deployment.yaml \
              -f ks8/mysql-service.yaml \
              -f ks8/job-backend-deployment.yaml \
              -f ks8/job-backend-service.yaml \
              -f ks8/job-frontend-deployment.yaml
