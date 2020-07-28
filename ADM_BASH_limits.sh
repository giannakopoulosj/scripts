#!/bin/bash
#checks the limits of the user.
#paste <(grep 'open files\|processes\|pending signals' /proc/self/limits | 
#        cut -c27-38)       <(i=`whoami` ; lsof -u $i | tail -n +2 | awk {'print $9'} | wc -l; 
#                     ps --no-headers -U $i -u $i u | wc -l ; 
#                     ps -u $i -o pid= | xargs printf "/proc/%s/status\n" |
#                                        xargs grep -s 'SigPnd' |
#                                        sed 's/.*\t//' | paste -sd+ | bc ; ) | while read a b ; do echo $a $b $((${b}00/a))%; done

i=$(whoami)

MProcesses=$(grep 'processes' /proc/self/limits| awk '{print $3}')
MOpenFiles=$(grep 'open files' /proc/self/limits| awk '{print $5}')
MPendingSignals=$(grep 'pending signals' /proc/self/limits| awk '{print $5}')

MyProcesses=$(ps --no-headers -U $i -u $i u | wc -l)
MyOpenFiles=$(lsof -u $i | tail -n +2 | awk {'print $9'} | wc -l)
MyPendingSignals=$(ps -u $i -o pid= | xargs printf "/proc/%s/status\n" | xargs grep -s 'SigPnd' | sed 's/.*\t//' | paste -sd+ | bc )



echo " For user $i"

echo "-------------------------------------------------------------"

echo " Max processes: $MProcesses "
echo " Max open files: $MOpenFiles "
echo " Max pending signals: $MPendingSignals "

echo "-------------------------------------------------------------"

echo "Processes      Max: $MProcesses Running: $MyProcesses   Percentage: $((${MyProcesses}00/MProcesses))% "
echo "OpenFiles      Max: $MOpenFiles Running: $MyOpenFiles   Percentage: $((${MyOpenFiles}00/MOpenFiles))% "
echo "PendingSignals Max: $MPendingSignals Running: $MyPendingSignals     Percentage: $((${MyPendingSignals}00/MPendingSignals))% "
