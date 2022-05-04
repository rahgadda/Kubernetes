#!/bin/bash

# -- Pre configurations
cat <<EOF |  tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# -- Download
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable --now kubelet

# -- Validate
kubectl version --short
kubeadm version --short

# -- Creating OS Services
systemctl enable docker.service
systemctl enable kubelet.service
systemctl daemon-reload
systemctl restart docker
systemctl restart kubelet

# -- Installing K8 Single Node Cluster
CERTKEY=$(kubeadm certs certificate-key)
kubeadm config images pull --cri-socket /run/cri-dockerd.sock
kubeadm init --apiserver-cert-extra-sans=cfs-lending.myvnc.com,152.70.78.41,10.0.0.145 --cri-socket /run/cri-dockerd.sock --pod-network-cidr=10.32.0.0/16  --service-cidr=10.33.0.0/16  --control-plane-endpoint=cfs-lending.myvnc.com --upload-certs --certificate-key=$CERTKEY

# -- Moving k8 config file  
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
mkdir -p /home/opc/.kube
cp $HOME/.kube/config /home/opc/.kube/config
chmod 777 /home/opc/.kube/config

# -- Validating Installation
echo "Check if Kubelt Ports Exposed"
netstat -nplt
echo "Check health of the Master Node"
kubectl get nodes
echo "Check Pod Status of kube-system"
kubectl get pods -n kube-system
echo "Check if --container-runtime-endpoint=/run/cri-dockerd.sock is enabled"
sudo cat /var/lib/kubelet/kubeadm-flags.env
# KUBELET_KUBEADM_ARGS="--container-runtime=remote --container-runtime-endpoint=/run/cri-dockerd.sock --pod-infra-container-image=k8s.gcr.io/pause:3.6"

# -- Enabling Flannel Networking
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
# kubectl apply -f https://docs.projectcalico.org/manifests/calico-typha.yaml
# kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

# -- Taint Master
## This will allow pods to be scheduled on Master
kubectl get nodes -o json | jq '.items[].spec.taints'
kubectl taint nodes k8-master node-role.kubernetes.io/master:NoSchedule- 