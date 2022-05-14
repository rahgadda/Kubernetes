#!/bin/sh

echo "MySQL Root Password: "
read password
echo "Password entered is - ${password}"
pbase64=`echo -ne ${password} | base64`
echo "Base64 Password - ${pbase64}"
rm -rf mysql.yaml
wget https://raw.githubusercontent.com/rahgadda/Kubernetes/master/MyDev/mysql.yaml 
sed -i "s/pbase64/$pbase64/g"  mysql.yaml
kubectl apply -f mysql.yaml
kubectl patch storageclass standard -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

# Verification
kubectl get StorageClass # sc
kubectl describe StorageClass local-storage
kubectl get PersistentVolume # pv
kubectl get PersistentVolumeClaim # pvc
kubectl describe PersistentVolumeClaim  mysql-local-pvc
kubectl get pods
kubectl describe pods mysql-0
kubectl get StatefulSets  # sts
kubectl describe StatefulSets mysql
kubectl get events
kubectl delete PersistentVolumeClaim  mysql-local-pvc-mysql-0
kubectl delete PersistentVolume local-pv
