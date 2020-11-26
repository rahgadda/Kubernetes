# Kubernetes

## VM
- Identify Servers as below
  - Master [M1   - whf00ddg.in.test.com]  
  - Node 1 [N1  - whf00dfb.in.test.com] 
  - Node 2 [N2   - whf00bbs.in.test.com]
- On all nodes perform below:
  ```bash
  $ sudo su
    # Configuring Docker
    $ cd /scratch
    $ mkdir -m777 docker_storage
    $ mkdir -m777 Home
    $ systemctl  stop docker
    # Enter ${USER}
    $ /usr/sbin/usermod -a -G docker rahgadda
    $ /usr/sbin/sysctl net.ipv4.conf.all.forwarding=1
    $ vi /etc/docker/daemon.json
      {
          "data-root":"/scratch/docker_storage"
      }
    $ vi /etc/sysconfig/docker
      export http_proxy="http://rmdc-proxy.test.com:80";
      export https_proxy="http://rmdc-proxy.test.com:80";
      export no_proxy="localhost,127.0.0.1,.testcorp.com,.in.test.com,10.40.65.121,10.96.0.1";
    $ systemctl  start docker
    $ chmod 777 /var/run/docker.sock
    
    # Configuring Network
    $ /usr/sbin/route
    $ /usr/sbin/setenforce 0
    $ yum install -y firewalld
    $ systemctl enable firewalld
    $ systemctl start firewalld
    $ /usr/sbin/iptables -P FORWARD ACCEPT
    $ firewall-cmd --direct --add-rule ipv4 filter FORWARD 0 -i eth0 -o eth1 -j ACCEPT
    $ firewall-cmd --add-masquerade --permanent
    $ firewall-cmd --add-port=10250/tcp --permanent
    $ firewall-cmd --add-port=8472/udp --permanent
    $ systemctl restart firewalld
    $ /usr/sbin/lsmod|grep br_netfilter
    
    # Install Repo
    $ yum install -y yum-utils
    $ yum repolist
    $ yum-config-manager --enable ol7_addons
    $ yum-config-manager --enable ol7_preview
    $ exit
  
  # Proxy Details
  $ export http_proxy="http://rmdc-proxy.test.com:80"
  $ export https_proxy="http://rmdc-proxy.test.com:80"
  $ export no_proxy="localhost,127.0.0.1,.testcorp.com,.in.test.com,10.40.65.121,10.96.0.1"
  
  # Validating Docker
  $ docker info
  $ docker run hello-world
  $ docker login container-registry.test.com
  ```
- On Master node perform below:
  ```bash
  $ sudo su
    $ docker login container-registry.test.com
    $ firewall-cmd --add-port=6443/tcp --permanent                           
    $ systemctl restart firewalld
    # $ yum-config-manager --enable ol7_UEKR5
    # Disable all containing with UEK except 5
    # $ yum-config-manager --disable ol7_UEKR4
    # $ yum update
    # $ yum list installed kernel*
    # $ uname -r [4.14.35-2020.el7uek.x86_64]
    $ yum install -y kubeadm
    $ /usr/sbin/sysctl -p /etc/sysctl.d/k8s.conf
    $ export PATH=$PATH:/usr/sbin
    # Record Token or generate using kubeadm token create --print-join-command
    $ kubeadm-setup.sh up --apiserver-advertise-address 10.40.65.121
    $ mkdir -p -m777 /scratch/k8/.kube
    $ cp -i /etc/kubernetes/admin.conf /scratch/k8/.kube/config
    $ chown 718508:8500 /scratch/k8/.kube/config
    $ exit
  $ export KUBECONFIG=/scratch/k8/.kube/config
  $ echo 'export KUBECONFIG=/scratch/k8/.kube/config' >> /home/rahgadda/.bashrc
  $ echo 'export KUBECONFIG=/scratch/k8/.kube/config' >> /home/rahgadda/.bash_profile
  ```
- On Nodes perform below:
  ```bash
  $ sudo su
    # Add Node to Cluster
    $ yum install -y kubeadm
    $ /usr/sbin/iptables -P FORWARD ACCEPT
    $ /usr/sbin/sysctl -p /etc/sysctl.d/k8s.conf
    $ export PATH=$PATH:/usr/sbin
    $ kubeadm-setup.sh join 10.40.65.121:6443 --token bjbie0.a4x13c4ovzx0xzcp --discovery-token-ca-cert-hash sha256:8ee9ecfb731228d016e8c4afc4163537d36458e2e27710ee530920f26186e37a
    # Remove Node from Cluster
    $ kubeadm-setup.sh stop
  ```
- Installing WebUI
  ```bash
  $ sudo su
    $ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
    $ kubectl label nodes whf00bbs kubernetes.io/os=linux
    $ kubectl label nodes whf00dfb kubernetes.io/os=linux
    $ kubectl get nodes --show-labels
    $ kubectl get deployments -n kubernetes-dashboard
    $ kubectl get events -n kubernetes-dashboard
    $ kubectl get pods -n kubernetes-dashboard
    $ kubectl logs kubernetes-dashboard-74485db5b8-bhmgf  -n kubernetes-dashboard
    $ kubectl exec --stdin --tty kubernetes-dashboard-74485db5b8-bhmgf -- /bin/bash
    # Creating Service Account
    $ kubectl create serviceaccount rahgadda -n default
    $ kubectl create clusterrolebinding dashboard-admin -n default --clusterrole=cluster-admin --serviceaccount=default:rahgadda
    $ kubectl describe serviceaccount rahgadda -n default
    $ kubectl describe secrets rahgadda-token-mtnw7 -n default
    $ kubectl create clusterrolebinding user-cluster-admin-binding --clusterrole=cluster-admin --user=default
    # Login
    CMD> ssh -L 9999:127.0.0.1:8001 -N -f -l rahgadda whf00ddg
    # Delete kubernetes-dashboard
    $ kubectl delete deployments kubernetes-dashboard -n kubernetes-dashboard
    $ kubectl delete deployments dashboard-metrics-scraper -n kubernetes-dashboard
  ```
- Basic Commands
  ```bash
  $ kubectl cluster-info
  # Display resources available on Kubernetes
  $ kubectl explain <resource_type>
  # This will return all resources of the type you're supplying
  $ kubectl get <resource_type>
  # Create all file in directory
  $ kubectl create -f <file>/<directory>
  # apply - makes incremental changes to an existing object                     [DeclarativeManagement]
  # create - creates a whole new object (previously non-existing / deleted)     [ImperativeManagement]
  $ kubectl apply -f <file>/<directory>
  # Update running container
  $ kubectl edit <resource_type> <resource_name>
  # Describe a running resource
  $ kubectl describe <resource_type> <resource_name_actual>/<creation_name>
  $ kubectl get nodes -o wide
  $ kubectl get nodes -o yaml
  $ kubectl get nodes -o json
  # kubectl run nginx --image=nginx --port=80
  $ kubectl run <name> --image=<container-image> --port=<container-port>
  # Get all STDIN and STDOUT logs
  $ kubectl logs -p <Pod Name> -c <Container>
  # Kubernetes maintains a timeline of all events that are created.
  $ kubectl get events
  ```

## PWK
- Free K8 Cluster is available [here](https://labs.play-with-k8s.com/)
- Setup
  ```sh
  # Create Master
  kubeadm init --apiserver-advertise-address $(hostname -i) --pod-network-cidr 10.5.0.0/16

  # Initialize Networking
  kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter.yaml

  # Create Nodes
  kubeadm join 192.168.0.8:6443 --token 7b0225.8lvnln4kjny3tagu \
    --discovery-token-ca-cert-hash sha256:e306f7fa636a8f32a7c6230c6e9d1f86a76bb2e4cfa2870051e698fd7eefa3da

  # Check Status
  kubectl get nodes -w

  # Run Dashboard
  curl -L -s https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.4/aio/deploy/recommended.yaml | sed 's/targetPort: 8443/targetPort: 8443\n  type: LoadBalancer/' | sed 's/- --auto-generate-certificates/- --auto-generate-certificates\n            - --enable-skip-login\n            - --disable-settings-authorizer/' | kubectl apply -f -
  
  # Verify Dashboard
  kubectl get pods -n kubernetes-dashboard
  kubectl get svc -n kubernetes-dashboard
  kubectl proxy --address='0.0.0.0' --disable-filter=true --accept-hosts='^*$' --port=80 &

  # Access Dashboard
  cat <<EOF | kubectl create -f -
  apiVersion: rbac.authorization.k8s.io/v1
  kind: ClusterRoleBinding
  metadata:
    name: kubernetes-dashboard2
    labels:
      k8s-app: kubernetes-dashboard
  roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: ClusterRole
    name: cluster-admin
  subjects:
  - kind: ServiceAccount
    name: kubernetes-dashboard
    namespace: kubernetes-dashboard
  EOF
  
  # Dashboard URL - Click Skip to Login
  http://<URL>/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login

  # Delete Dashboard
  curl -L -s https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.4/aio/deploy/recommended.yaml | sed 's/targetPort: 8443/targetPort: 8443\n  type: LoadBalancer/' | sed 's/- --auto-generate-certificates/- --auto-generate-certificates\n            - --enable-skip-login\n            - --disable-settings-authorizer/' | kubectl delete -f -

  # General Commands
  kubectl get pods
  kubectl run nginx --image=nginx:latest --replicas=4
  kubectl delete pods nginx
  ```

## Examples
- Creating Nginx Pod example
```sh
# Run Nginx Server
kubectl apply -f https://k8s.ioexamplescontrollers/  nginx-deployment.yaml
kubectl get pods -w
kubectl get deployments
kubectl expose deploy/nginx-deployment --port  80--type=LoadBalancer
kubectl get svc

# Delete Nginx Server
kubectl delete deployments nginx-deployment
kubectl delete svc nginx-deployment
```