#!/bin/sh

echo "MySQL Root Password: "
read password
echo "Password entered is - ${password}"
pbase64=`echo -ne ${password} | base64`
echo "Base64 Password - ${pbase64}"
rm -rf mysql.yaml
wget https://raw.githubusercontent.com/rahgadda/Kubernetes/master/MyDev/mysql.yaml 
sed -i "s/pbase64/$pbase64/g"  mysql.yaml