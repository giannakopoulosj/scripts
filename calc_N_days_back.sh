#!/bin/bash
#Working in Linux not in SunOS/AIX
#to impelement check


_DAYSBACK=$(date -d "-$1 day" +'%Y%m%d')
echo $_DAYSBACK
