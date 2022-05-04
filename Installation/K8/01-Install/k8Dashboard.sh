#!/bin/bash

# -- Install Dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml

# -- Verify Dashboard 
kubectl get svc -n kubernetes-dashboard
kubectl get pods -n kubernetes-dashboard

# -- Create Service Account to Access Dashboard
kubectl create serviceaccount rahgadda -n default
kubectl create clusterrolebinding dashboard-admin -n default --clusterrole=cluster-admin --serviceaccount=default:rahgadda
kubectl create clusterrolebinding user-cluster-admin-binding --clusterrole=cluster-admin --user=default

# -- Create Config file to Login
server=https://cfs-lending.myvnc.com:6443
name=$(kubectl get serviceaccount rahgadda -n default -o jsonpath="{.secrets[0].name}")
ca=$(kubectl get secret/$name -o jsonpath='{.data.ca\.crt}')
token=$(kubectl get secret/$name -o jsonpath='{.data.token}' | base64 --decode)
namespace=$(kubectl get secret/$name -o jsonpath='{.data.namespace}' | base64 --decode)

echo "
apiVersion: v1
kind: Config
clusters:
- name: default-cluster
  cluster:
    certificate-authority-data: ${ca}
    server: ${server}
contexts:
- name: default-context
  context:
    cluster: default-cluster
    namespace: default
    user: default-user
current-context: default-context
users:
- name: default-user
  user:
    token: ${token}
" > cfs-lending-kubeconfig.yaml

echo "Use cfs-lending-kubeconfig.yaml file to login to Dashboard"


# -- Create Ingress for Dashboard Service k8-dashboard-ingress.yaml k8-dashboard-cert-ingress.yaml
kubectl apply -f https://raw.githubusercontent.com/rahgadda/Kubernetes/master/MyDev/k8-dashboard-ingress.yaml

echo ""
echo "Dashboard will be available at URL https://cfs-lending.myvnc.com/dashboard/, https://cfs-lending.myvnc.com:6443/api/v1"
echo ""