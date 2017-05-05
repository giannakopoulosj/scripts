##Not working:
#SunOS xxxxx 5.10 Generic_147440-01 sun4u sparc SUNW,SPARC-Enterprise
#SunOS xxxxx 5.10 Generic_147440-01 sun4v sparc sun4v
#SunOS xxxxx 5.10 Generic_150400-09 sun4v sparc sun4v

##Working:
#SunOS xxxxx 5.11 11.1 sun4v sparc sun4v
#Linux xxxxx 3.8.13-68.3.4.el6uek.x86_64 #2 SMP Tue Jul 14 15:03:36 PDT 2015 x86_64 x86_64 x86_64 GNU/Linux

##Code:

#!/bin/bash
_START_TIME=$(date +%s)
Commands to measure time
_END_TIME=$(date +%s)

_TOTAL_TIME=$((($_END_TIME-$_START_TIME)))

echo "Total execition time was: $_TOTAL_TIME in seconds"
