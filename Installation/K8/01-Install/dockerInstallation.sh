#!/bin/bash

# -- Enable kernel modules
modprobe overlay
modprobe br_netfilter
cat <<EOF |  tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
cat <<EOF |  tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sysctl --system

# -- Disabling Swap Memory
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

## Podman is by default provided, K8 can run on Podman
## I was unable to install using Podman and need to move to docker
# -- Remove Podman
yum remove podman buildah  -y

# -- Install Docker
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io

# -- Configure Docker
systemctl  stop docker
/usr/sbin/usermod -a -G docker opc
/usr/sbin/sysctl net.ipv4.conf.all.forwarding=1
systemctl  start docker
chmod 777 /var/run/docker.sock
tee /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
# -- Start and enable Services
sudo systemctl daemon-reload 
sudo systemctl restart docker
sudo systemctl enable docker
# -- Installin cri-dockerd
VER=$(curl -s https://api.github.com/repos/Mirantis/cri-dockerd/releases/latest|grep tag_name | cut -d '"' -f 4)
echo $VER
wget https://github.com/Mirantis/cri-dockerd/releases/download/${VER}/cri-dockerd-${VER}-linux-arm64.tar.gz
tar xvf cri-dockerd-${VER}-linux-arm64.tar.gz
install -o root -g root -m 0755 cri-dockerd /usr/bin/cri-dockerd
cp cri-dockerd /usr/bin/
# -- Verification
cri-dockerd --version
# -- Configure systemd units for cri-dockerd
wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.service
wget https://raw.githubusercontent.com/Mirantis/cri-dockerd/master/packaging/systemd/cri-docker.socket
sudo cp cri-docker.socket cri-docker.service /etc/systemd/system/ 
sudo cp cri-docker.socket cri-docker.service /usr/lib/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable cri-docker.service
sudo systemctl enable --now cri-docker.socket
# -- Using cri-dockerd on new Kubernetes cluster
systemctl status docker | grep Active

# -- Verification
echo "Swap memory details"
swapon --show
echo "checking br_netfilter"
lsmod | grep br_netfilter
echo "Verify Docker"
systemctl status docker | grep Active
echo "Verify CRI-Docker Shim"
systemctl status cri-docker.socket | grep Active
systemctl status cri-docker.socket | grep Listen