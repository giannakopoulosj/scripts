#!/bin/bash

docker volume create portainer_data

docker run -d \
-p 8000:8000 \
-p 9443:9443 \
--restart always  \
--name portainer \
-v .:/certs \
-v /var/run/docker.sock:/var/run/docker.sock \
-v portainer_data:/data portainer/portainer-ce:2.20.1 \
--sslcert /certs/portainer.crt \
--sslkey /certs/portainer.key