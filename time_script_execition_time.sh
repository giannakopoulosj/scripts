#!/bin/bash
#with python

microtime() {
    python -c 'import time; print time.time()'
}



main() {
local START=$(microtime)
#call your script
local END=$(microtime)
DIFF=$(echo "$END - $START" | bc)
echo "$0 run in $DIFF seconds"
}


main
