#!/bin/sh

echo "MySQL Root Password: "
read password
echo "Password entered is - ${password}"
pbase64=`echo -ne ${password} | base64`
echo "Base64 Password - ${pbase64}"

sed -e 's|MYAPP|my-nginx|g' test-deploy.yaml | kubectl apply -f -