#!/bin/bash

while IFS=" " read -r server username password;do
timeout 3 ssh -n $username@$server 'exit 66'
if [ $? -eq 66 ] ;then
echo "Key exist on $server"
else
./my.exp $server $username $password
fi

done < input_file.txt