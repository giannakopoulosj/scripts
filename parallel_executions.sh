#!/bin/bash

SCRIPTS=*.sql
pids=""

for SCRIPT in $SCRIPTS ; do
  $ORACLE_HOME/bin/sqlplus -s $DBLOGIN/$DBPASS@$ORACLE_SID @$SCRIPT &
  pids+=" $!"
  echo "PID of $SCRIPT is: $(echo $pids|awk '{print $NF}')"
done


for p in $pids; do
 if wait $p; then
    echo "Process $p success"
 else
    echo "Process $p fail"
    exit 1
 fi
done
