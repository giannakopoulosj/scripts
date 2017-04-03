#!/bin/bash



#Linux
_DAYSBACK=$(date -d "-$1 day" +'%Y%m%d')
echo $_DAYSBACK

#non linux systems AIX??? / SOLARIS
_DAYS=1
echo $(TZ=a$(((24*$_DAYS))) date +'%Y%m%d')
