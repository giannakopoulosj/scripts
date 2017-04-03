#!/bin/bash



#Linux
_DAYSBACK=$(date -d "-$1 day" +'%Y%m%d')
echo $_DAYSBACK

#non linux systems AIX??? / SOLARIS
_DAYS=1
echo $(TZ=a$(((24*$_DAYS))) date +'%Y%m%d')

#TEST FOR SOLARIS change + to - for dates in the future.
_A_DAY=24
_TODAY=$(date +%Y%m%d)
_TWO_DAYS=$(TZ=CST+$(((2*$_A_DAY))) date +'%Y%m%d')
_THREE_DAYS=$(TZ=CST+$(((3*$_A_DAY))) date +'%Y%m%d')

echo "Today is $_TODAY"
echo "Two days back was $_TWO_DAYS"
echo "Three days back was $_THREE_DAYS"
