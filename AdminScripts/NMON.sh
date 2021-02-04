#!/bin/bash
#0 * * * * NMON.sh
nmon_file_path="/opt/NMON"
/usr/bin/topas_nmon -^ -T -F $nmon_file_path/nmon_$(date +%d%m%Y_%H%m)_$(hostname).csv -s15 -c240
chmod 666 $nmon_file_path/nmon_$(date +%d%m%Y_%H%m)_$(hostname).csv
find $nmon_file_path/ -type f -name "nmon*.csv" -mtime +10 -exec rm {} \;

