#!/bin/bash

# -- Adding Chart
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm repo list

# -- Run Ingress Chart
kubectl create ns ingress-nginx
chmod 777 ngingress-metal-custom.yaml
helm install helm-ngingress ingress-nginx/ingress-nginx -n ingress-nginx --values ngingress-metal-custom.yaml

# -- Verification
kubectl get all -n ingress-nginx
helm list -n ingress-nginx