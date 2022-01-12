#!/bin/bash

cat ~/.kube/config | grep certificate-authority-data | awk -F: '{print $2}' | tr -d ' ' | base64 -d > ca.crt
cat ~/.kube/config | grep client-certificate-data | awk -F: '{print $2}' | tr -d ' ' | base64 -d > client.crt
cat ~/.kube/config | grep client-key-data | awk -F: '{print $2}' | tr -d ' ' | base64 -d > client.key
openssl pkcs12 -export -out cert.pfx -inkey client.key -in client.crt -certfile ca.crt
