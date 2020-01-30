#!/bin/bash
#0 * * * * NMON.sh
/usr/bin/topas_nmon -^ -T -F /opt/NMON/nmon_$(date +%d%m%Y_%H%m)_$(hostname).csv -s15 -c240
chmod 666 /opt/NMON/nmon_$(date +%d%m%Y_%H%m)_$(hostname).csv
find /opt/NMON/ -type f -name "nmon*.csv" -mtime +10 -exec rm {} \;

