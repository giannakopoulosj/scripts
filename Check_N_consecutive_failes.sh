#!/bin/bash

#Number to get the last N executions
N=5
CONSECUTIVE_FAILES=0

cd /foo/bar || exit 1

FILES=$(ls -tr /foo/bar |tail -"$N")

for FILE in $FILES
do
if [[ -s $FILE ]] #FIle is greater than 0
then
((CONSECUTIVE_FAILES++))
fi
done

echo "Total consecutive files failed: $CONSECUTIVE_FAILES ..."

if [[ CONSECUTIVE_FAILES -eq $N ]]
then
echo "Incident need to be open to CRM Services..."
exit 1
fi
