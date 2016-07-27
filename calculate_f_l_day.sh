#!/bin/bash
set $(date +%m" "%Y)
CURMTH=$1
CURYR=$2
 
if [ $CURMTH -eq 1 ]
then PRVMTH=12
    PRVYR=$(expr $CURYR - 1)
else PRVMTH=$(expr $CURMTH - 1)
    PRVYR=$CURYR
fi
 
if [ $PRVMTH -lt 10 ]
then PRVMTH="0"$PRVMTH
fi
 
 
LASTDY=$(cal $PRVMTH $PRVYR | egrep "28|29|30|31" |tail -1 |awk '{print $NF}')
 
echo First Day: 01-$PRVMTH-$PRVYR
echo Last Day: $LASTDY-$PRVMTH-$PRVYR
