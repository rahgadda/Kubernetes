#!/bin/bash

##Helm 
helm list --all-namespaces
helm delete helm-ngingress -n ingress-nginx

kubectl drain k8-master --delete-emptydir-data --force --ignore-daemonsets
kubectl delete node k8-master
kubeadm reset
iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
iptables -L -n

rm -rf /etc/kubernetes
rm -rf /etc/cni/net.d
rm -rf /var/lib/kubelet
rm -rf /var/lib/etcd
rm -rf $HOME/.kube
rm -rf /home/opc/.kube

ip link delete cni0
ip link delete flannel.1
ip link