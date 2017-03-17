#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    echo "Usage is ./$0 n_of_files from_path to_path"
fi


_TPATH=/foo/bar
_DPATH=/dest/path

#_TPATH=$2
#_DPATH=$3


FILES=$(ls $_TPATH | head -"$1")
for FILE in $FILES
do
echo "Moving $FILE"
mv $_TPATH/$FILE $_DPATH/$FILE
done
