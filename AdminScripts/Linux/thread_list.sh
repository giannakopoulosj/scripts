#!/bin/bash

ps -ef --no-headers | while read line; do                 # for each process read the info (without headers)
   IFS='        ' read -r -a array <<< "$line"             # split info into array
   psResultStr="ps -p ${array[1]} -lfT |  wc -c"           # count how many threads per PID
   numThreads=$(eval $psResultStr)                         # trying to convert it to number so i can filter later
   if [ "$numThreads" -gt "1000" ]                          #only show process with 1K or more
   then
        printf "Number of threads for PID:${array[1]} Has $numThreads Threads.  Process info: "
              for ((i = 7; i < ${#array[@]}; ++i)); do       #Process info starts at idx 7
                                position=$(( $i + 1 ))  # bash arrays are 0-indexed
                                lineText=$(echo ${array[$i]}|tr -d '\n')   # remove any new lines
                                printf "%s" "$lineText"                     #output line item
                        done
                        printf "\n\n"
   fi
done
