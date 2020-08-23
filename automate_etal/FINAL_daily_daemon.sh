#!/bin/bash

##VARIABLES for Deamon##

#Time variables
S_TIME_END="2359"
S_DAYTIME_END="$(date +%Y%m%d)$S_TIME_END"
WAIT_TIME_LOOP="60"


while [ $S_DAYTIME_END -gt $(date +%Y%m%d%H%M) ]; do

#Daily Daemon actions with variable waiting loop

echo -e "Check every $(( WAIT_TIME_LOOP / 60 )) minutes and $(( WAIT_TIME_LOOP % 60 )) seconds.\n\n"
sleep $WAIT_TIME_LOOP
done
