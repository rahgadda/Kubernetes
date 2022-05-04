#!/bin/bash

# -- Delete k8-dashboard-ingress
kubectl delete -f https://raw.githubusercontent.com/rahgadda/Kubernetes/master/MyDev/k8-dashboard-ingress.yaml

# -- Adding Certificate Manager Kubernetes Plugin
curl -L -o kubectl-cert-manager.tar.gz  https://github.com/jetstack/cert-manager/releases/latest/download/kubectl-cert_manager-linux-arm64.tar.gz
tar xzf kubectl-cert-manager.tar.gz
sudo mv kubectl-cert_manager /usr/bin
# -- Verification Certificate Manager Kubernetes Plugin
echo "Verifying Certificate Manager Kubernetes Plugin"
kubectl cert-manager help
kubectl cert-manager check api

# -- Create Custom Resource Definition https://cert-manager.io/
kubectl create ns cert-manager
kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.8.0/cert-manager.yaml
# -- Verifications
kubectl get CustomResourceDefinition -A
kubectl get pods -n cert-manager
kubectl get Secret -A | grep letsencrypt-stage-secret

# -- Creating Certificate Issuer
kubectl apply -f https://raw.githubusercontent.com/rahgadda/Kubernetes/master/MyDev/cert-cluster-issue.yaml
# -- Verifications
kubectl get ClusterIssuers -A
kubectl describe ClusterIssuer letsencrypt-prd-issuer -n cert-manager
# kubectl get Issuers -A

# -- Creating Certificate
kubectl apply -f https://raw.githubusercontent.com/rahgadda/Kubernetes/master/MyDev/cert-certificate.yaml
# -- Verifications
kubectl logs $(kubectl get pods --no-headers -o custom-columns=":metadata.name" -n cert-manager | awk '{print $1}'| awk 'NR==1{print $1}') -n cert-manager 
kubectl get Secret -A | grep  letsencrypt-prd-certificate-secret
kubectl get Certificates -A
kubectl describe Certificates letsencrypt-prd-certificate -n cert-manager
kubectl get CertificateRequests -A
kubectl get Orders -A
kubectl get Challenges -A
# kubectl describe CertificateRequests letsencrypt-prd-certificate-<> -n cert-manager
# kubectl describe Orders letsencrypt-prd-certificate-<> -n cert-manager
kubectl get events -A

# -- Create Ingress for Dashboard Service k8-dashboard-ingress.yaml k8-dashboard-cert-ingress.yaml
kubectl apply -f https://raw.githubusercontent.com/rahgadda/Kubernetes/master/MyDev/k8-dashboard-cert-ingress.yaml
echo ""
echo "Dashboard will be available at URL https://cfs-lending.myvnc.com/dashboard/, https://cfs-lending.myvnc.com:6443/api/v1"
echo ""