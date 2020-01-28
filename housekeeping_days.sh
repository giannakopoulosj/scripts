#!/bin/bash

#housekeep script for more than 30 days


MTIME=30
pids=""



FILE_DIR1="/path1"
LOG_DIR1="/scriptlog/housekeep_bt_gr_in_$(date +'%Y%m%d').log"

FILE_DIR2="/path2"
LOG_DIR2="/scriptlog/housekeep_bt_cy_in_$(date +'%Y%m%d').log"

FILE_DIR3="/path3"
LOG_DIR3="/scriptlog/housekeep_gpp_in_$(date +'%Y%m%d').log"

FILE_DIR4="/path4"
LOG_DIR4="/scriptlog/housekeep_gpp_feeder_$(date +'%Y%m%d').log"


clean_data_files () {
local  FILE_DIR=$1
local  LOG_DIR=$2

  find "$FILE_DIR" -type f -mtime +"$MTIME"  | tee "$LOG_DIR"
  find "$FILE_DIR" -type f -mtime +"$MTIME" -exec rm {} \; 

}

clean_data_files "$FILE_DIR1" "$LOG_DIR1" &
  pids+=" $!"
clean_data_files "$FILE_DIR2" "$LOG_DIR2" &
  pids+=" $!"
clean_data_files "$FILE_DIR3" "$LOG_DIR3" &
  pids+=" $!"
clean_data_files "$FILE_DIR4"" $LOG_DIR4" &
  pids+=" $!"


for p in $pids; do
 if wait "$p"; then
    echo "Process $p success"
 else
    echo "Process $p fail"
    exit 1
 fi
done
