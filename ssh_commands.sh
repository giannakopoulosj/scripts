#!/bin/bash

#SFTP on specific port
sftp -oPort=1234 user@123.456.789.012

#Change working directory direct on sftp connection
sftp user@123.456.789.012:/home/something
