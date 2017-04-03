#!/bin/bash
 
while [  $(ls | wc -l) -ne 0 ]; do
_counter=150
_sleeping_period=600
#counter=$1
#sleeping_period=$2
 
#first_file=$(ls | head -$_counter)
for _FILE in $(ls| grep -v $(basename $0) | head -$_counter) #first_file
do
#if [ "$_FILE" -a *.xml ];
#then
    echo "Moving file $_FILE"
    mv "$_FILE" /foo/bar
#else
#             exit 0
#fi
done
echo "Sleeping for $_sleeping_period seconds"
sleep $_sleeping_period
done
 
 
#with addition need to be added to report remaining files.
#while true;do echo "total: $(ls ../tmp_for_backlog/ | wc -l) active: $(ls | wc -l)"; sleep 10;done
