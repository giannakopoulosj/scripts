#!/bin/bash
#0 * * * * NMON.sh
/usr/bin/topas_nmon -^ -T -F /patches/nmon/nmon_$(date +%d%m%Y_%H%m)_$(hostname).csv -s15 -c240
chmod 666 /patches/nmon/nmon_$(date +%d%m%Y_%H%m)_$(hostname).csv
