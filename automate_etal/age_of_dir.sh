#!/bin/bash


if [ -z $1 ]
then
echo "Usage: \n $(basename $0) <directory> "
exit 1
fi


time=$((($(date +"%s")-$(stat --printf="%Y" $1))))
#echo $time

if [ $time -gt 3600 ]
then
echo "Time of last modification as seconds since Epoch is $time for Directory: $1"
exit 1
else
echo "Time of last modification as seconds since Epoch is $time for Directory: $1"
exit 0
fi
