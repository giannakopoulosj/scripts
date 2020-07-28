#!/bin/bash
#checks the limits of the user.
paste <(grep 'open files\|processes\|pending signals' /proc/self/limits | 
        cut -c27-38)       <(i=`whoami` ; lsof -u $i | tail -n +2 | awk {'print $9'} | wc -l; 
                     ps --no-headers -U $i -u $i u | wc -l ; 
                     ps -u $i -o pid= | xargs printf "/proc/%s/status\n" |
                                        xargs grep -s 'SigPnd' |
                                        sed 's/.*\t//' | paste -sd+ | bc ; ) | while read a b ; do echo $a $b $((${b}00/a))%; done
