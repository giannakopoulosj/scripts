#!/bin/bash

  join -t / -1 3 -2 3 \
    <(grep VmSwap /proc/*/status  |egrep -v '/proc/self|thread-self' | sort -k3,3 --field-separator=/ ) \
    <(grep -H  '' --binary-files=text /proc/*/cmdline |tr '\0' ' '|cut -c 1-200|egrep -v '/proc/self|/thread-self'|sort -k3,3 --field-separator=/ ) \
    | cut -d/ -f1,4,7- \
    | sed 's/status//; s/cmdline//' \
    | sort -h -k3,3 --field-separator=:\
    | tee >(awk -F: '{s+=$3} END {printf "\nTotal Swap Usage = %.0f kB\n",s}') /dev/null
