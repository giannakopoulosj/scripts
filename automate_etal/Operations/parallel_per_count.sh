#!/bin/bash
parallel_level=5
my_directory=.
my_files=$(ls -d $my_directory/BCH*)
pids=""

for my_file in $my_files; do
echo $my_file &
pids+=" $!"
echo "PID of $SCRIPT is: $(echo $pids|awk '{print $NF}')"

bg_procs=$(wc -w <<< $pids)


#go to check if the thread level is in place
if [ $((($bg_procs%$parallel_level))) -eq 0  ];then

for p in $pids; do
 if wait $p; then
    echo "Process $p success"
 else
    echo "Process $p fail"
    exit 1
 fi
done

#flush the metrics and get new files...
bg_procs=""
pids=""
fi

done
