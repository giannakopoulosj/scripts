# Setting up the Certificate Authority (CA)
`openssl genrsa -out ca.key 2048`  
`openssl req -new -x509 -days 365 -key ca.key -out ca.crt`


## Generate a private key for your server:
`openssl genrsa -out server.key 2048`

## Create a Certificate Signing Request (CSR) for your server:
`openssl req -new -key server.key -out server.csr -subj "/CN=localhost"`

## Generate the SSL certificate signed by your CA with the wildcard domain:
`openssl x509 -req -days 365 -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -extfile <(printf "subjectAltName=DNS:*.localhost,DNS:localhost")`


