#!/bin/bash

_DAYSBACK=$(date -d "-$1 day" +'%Y%m%d')
echo $_DAYSBACK
