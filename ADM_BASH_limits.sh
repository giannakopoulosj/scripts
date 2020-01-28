#!/bin/bash

paste <(grep 'processes\| open files\|pending signals' /proc/self/limits | cut -c27-38)       <(i=`whoami` ; ps --no-headers -U $i -u $i u | wc -l ; lsof -u $i | tail -n +2 | awk {'print $9'} | wc -l; 
        ps -u $i -o pid= | xargs printf "/proc/%s/status\n" | xargs grep -s 'SigPnd' | sed 's/.*\t//' | paste -sd+ | bc ; ) |  while read a b ; do echo $a $b; done


