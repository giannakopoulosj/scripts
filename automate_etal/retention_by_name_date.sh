#!/bin/bash

#Configuration
myRetention=1
myRetentionType="month" #day|month|year

while read myData; do 
#data segregation
myPath=$(echo $myData|awk '{print $1}')
myFile=$(echo $myData|awk '{print $2'})
#echo $myFile ${myFile:0:8}

#Data check and clean
if [ ${myFile:0:8} -lt $(date -d "-$myRetention $myRetentionType" +'%Y%m%d') ];then
#echo $myFile ${myFile:0:8} $(date -d "-3 month" +'%Y%m%d')
echo $myPath/$myFile
fi
done < <(find /inputfiles/ -type f -name "*.txt"  -printf "%h  %f\n")
