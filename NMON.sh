#!/bin/bash
/usr/bin/topas_nmon -^ -T -F /patches/nmon/nmon_$(date +%d%m%Y)_$(hostname).csv -s120 -c719
chmod 666 /patches/nmon/nmon_$(date +%d%m%Y)_$(hostname).csv
