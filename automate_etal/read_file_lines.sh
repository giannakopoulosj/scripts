#!/bin/bash
input="/etc/hosts"
while IFS= read -r line
do
  echo "$line"
done < "$input"
