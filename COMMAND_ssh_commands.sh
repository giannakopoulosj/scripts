#!/bin/bash

#SFTP on specific port
sftp -oPort=1234 user@123.456.789.012

sftp -oIdentityFile=other_rsa user@123.456.789.012

sftp -i ther_rsa user@123.456.789.012

#Change working directory direct on sftp connection
sftp user@123.456.789.012:/home/something

#Generate public key out of private.
ssh-keygen -y -f ~/.ssh/id_rsa 
