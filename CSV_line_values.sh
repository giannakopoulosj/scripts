#!/bin/bash

INPUT=data.cvs
OLDIFS=$IFS
IFS=,
#IFS=$1 

[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read F1 F2 F3 F4 F5 F6 F7 F8 F9 F10
do
  echo "First_VAR : $F1"
  echo "Second_VAR : $F2"
  echo "Third_VAR : $F3"
  echo "Fourth_VAR : $F4"
  echo "Fifth_VAR : $F5"
  echo "Sixth_VAR : $F6"
  echo "Seventh_VAR : $F7"
  echo "Eighth_VAR : $F8"
  echo "Ninth_VAR : $F9"
  echo "Tensh_VAR : $F10"
  
done < $INPUT
IFS=$OLDIFS
